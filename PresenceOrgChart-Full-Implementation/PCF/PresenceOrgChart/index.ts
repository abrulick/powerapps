import { IInputs, IOutputs } from "./generated/ManifestTypes";

interface OrgPerson {
    key: string;
    name: string;
    managerKey: string;
    managerName: string;
    workType: string;
    location: string;
    presenceStatus: string;
    presenceText: string;
    children: OrgPerson[];
    synthetic?: boolean;
}

interface LayoutNode {
    person: OrgPerson;
    x: number;
    y: number;
    depth: number;
    visibleChildren: LayoutNode[];
}

interface Bounds {
    minX: number;
    minY: number;
    maxX: number;
    maxY: number;
}

export class PresenceOrgChart implements ComponentFramework.StandardControl<IInputs, IOutputs> {
    private container!: HTMLDivElement;
    private toolbar!: HTMLDivElement;
    private chartHost!: HTMLDivElement;
    private searchInput!: HTMLInputElement;
    private statusSummary!: HTMLDivElement;
    private notifyOutputChanged!: () => void;

    private people: OrgPerson[] = [];
    private rootData?: OrgPerson;
    private layoutByKey = new Map<string, LayoutNode>();
    private currentLayoutNodes: LayoutNode[] = [];
    private collapsedKeys = new Set<string>();

    private selectedEmployeeKey = "";
    private selectedEmployeeName = "";
    private selectedPresenceText = "";

    private viewport?: SVGGElement;
    private currentSvg?: SVGSVGElement;
    private scale = 1;
    private tx = 0;
    private ty = 0;

    private lastDataSignature = "";
    private lastWidth = 0;
    private lastHeight = 0;

    private readonly nodeWidth = 220;
    private readonly nodeHeight = 92;
    private readonly horizontalGap = 42;
    private readonly verticalGap = 78;
    private readonly minScale = 0.12;
    private readonly maxScale = 2.5;

    public init(
        context: ComponentFramework.Context<IInputs>,
        notifyOutputChanged: () => void,
        _state: ComponentFramework.Dictionary,
        container: HTMLDivElement
    ): void {
        this.container = container;
        this.notifyOutputChanged = notifyOutputChanged;
        context.mode.trackContainerResize(true);

        this.container.classList.add("presence-org-chart");
        this.buildShell();

        // This implementation is designed for a small department. Ask the
        // dataset for a page size large enough to cover the expected weekly
        // employee population in one page.
        try {
            context.parameters.OrgData.paging.setPageSize(500);
        } catch {
            // Some host states do not expose paging immediately. The control
            // still renders the records that are supplied by the host.
        }
    }

    public updateView(context: ComponentFramework.Context<IInputs>): void {
        const dataSet = context.parameters.OrgData;

        if (!dataSet || dataSet.loading) {
            this.renderMessage("Loading organization…");
            return;
        }

        const people = this.readPeople(dataSet);
        const width = Math.max(context.mode.allocatedWidth || this.container.clientWidth, 600);
        const height = Math.max(context.mode.allocatedHeight || this.container.clientHeight, 420);
        const signature = this.makeSignature(people);

        if (people.length === 0) {
            this.people = [];
            this.rootData = undefined;
            this.lastDataSignature = signature;
            this.updateStatusSummary();
            this.renderMessage("No presence records are available for the selected weekday.");
            return;
        }

        const dataChanged = signature !== this.lastDataSignature;
        const sizeChanged = width !== this.lastWidth || height !== this.lastHeight;

        this.people = people;
        this.rootData = this.buildTree(people);
        this.updateStatusSummary();

        if (dataChanged) {
            // A date/week change can alter the selected person's presence.
            // Clear selection so the app never shows stale selected details.
            if (this.selectedEmployeeKey) {
                this.selectedEmployeeKey = "";
                this.selectedEmployeeName = "";
                this.selectedPresenceText = "";
            }

            // Remove collapse-state keys that no longer exist.
            const validKeys = new Set(people.map(p => p.key));
            for (const key of Array.from(this.collapsedKeys)) {
                if (!validKeys.has(key)) {
                    this.collapsedKeys.delete(key);
                }
            }
        }

        if (dataChanged || sizeChanged || !this.currentSvg) {
            this.renderTree(true);
            this.lastDataSignature = signature;
            this.lastWidth = width;
            this.lastHeight = height;
        }
    }

    public getOutputs(): IOutputs {
        return {
            SelectedEmployeeKey: this.selectedEmployeeKey,
            SelectedEmployeeName: this.selectedEmployeeName,
            SelectedPresenceText: this.selectedPresenceText
        };
    }

    public destroy(): void {
        this.container.replaceChildren();
    }

    private buildShell(): void {
        this.container.replaceChildren();

        this.toolbar = document.createElement("div");
        this.toolbar.className = "presence-org-chart__toolbar";

        this.searchInput = document.createElement("input");
        this.searchInput.className = "presence-org-chart__search";
        this.searchInput.type = "search";
        this.searchInput.placeholder = "Search employee";
        this.searchInput.setAttribute("aria-label", "Search employee");
        this.searchInput.addEventListener("keydown", event => {
            if (event.key === "Enter") {
                event.preventDefault();
                this.searchEmployee(this.searchInput.value);
            }
        });
        this.toolbar.appendChild(this.searchInput);

        this.toolbar.appendChild(this.makeToolbarButton("Search", () => this.searchEmployee(this.searchInput.value)));
        this.toolbar.appendChild(this.makeToolbarButton("Fit all", () => this.fitAll()));
        this.toolbar.appendChild(this.makeToolbarButton("−", () => this.zoomAtCenter(0.85), "Zoom out"));
        this.toolbar.appendChild(this.makeToolbarButton("+", () => this.zoomAtCenter(1.18), "Zoom in"));
        this.toolbar.appendChild(this.makeToolbarButton("Expand all", () => {
            this.collapsedKeys.clear();
            this.renderTree(true);
        }));
        this.toolbar.appendChild(this.makeToolbarButton("Collapse all", () => {
            for (const person of this.people) {
                if (person.children.length > 0) {
                    this.collapsedKeys.add(person.key);
                }
            }
            if (this.rootData && !this.rootData.synthetic) {
                this.collapsedKeys.delete(this.rootData.key);
            }
            this.renderTree(true);
        }));

        this.statusSummary = document.createElement("div");
        this.statusSummary.className = "presence-org-chart__summary";
        this.toolbar.appendChild(this.statusSummary);

        this.chartHost = document.createElement("div");
        this.chartHost.className = "presence-org-chart__host";

        this.container.appendChild(this.toolbar);
        this.container.appendChild(this.chartHost);
    }

    private makeToolbarButton(text: string, action: () => void, ariaLabel?: string): HTMLButtonElement {
        const button = document.createElement("button");
        button.type = "button";
        button.className = "presence-org-chart__button";
        button.textContent = text;
        button.setAttribute("aria-label", ariaLabel || text);
        button.addEventListener("click", action);
        return button;
    }

    private readPeople(dataSet: ComponentFramework.PropertyTypes.DataSet): OrgPerson[] {
        const result: OrgPerson[] = [];
        const seen = new Set<string>();

        for (const recordId of dataSet.sortedRecordIds) {
            const record = dataSet.records[recordId];
            if (!record) {
                continue;
            }

            const key = this.readValue(record, "EmployeeKey").trim().toLowerCase();
            if (!key || seen.has(key)) {
                continue;
            }
            seen.add(key);

            result.push({
                key,
                name: this.readValue(record, "EmployeeName") || key,
                managerKey: this.readValue(record, "ManagerKey").trim().toLowerCase(),
                managerName: this.readValue(record, "ManagerName"),
                workType: this.readValue(record, "WorkType"),
                location: this.readValue(record, "WorkLocation"),
                presenceStatus: this.readValue(record, "PresenceStatus"),
                presenceText: this.readValue(record, "PresenceText"),
                children: []
            });
        }

        return result;
    }

    private readValue(record: any, columnName: string): string {
        const raw = record.getValue(columnName);
        return raw === null || raw === undefined ? "" : String(raw);
    }

    private makeSignature(people: OrgPerson[]): string {
        return people
            .map(p => [p.key, p.managerKey, p.workType, p.location, p.presenceStatus, p.presenceText].join("|"))
            .sort()
            .join("||");
    }

    private buildTree(people: OrgPerson[]): OrgPerson {
        const byKey = new Map<string, OrgPerson>();
        for (const person of people) {
            person.children = [];
            byKey.set(person.key, person);
        }

        const roots: OrgPerson[] = [];

        for (const person of people) {
            const manager = person.managerKey ? byKey.get(person.managerKey) : undefined;
            if (!manager || manager.key === person.key || this.relationshipWouldCreateCycle(person.key, manager.key, byKey)) {
                roots.push(person);
            } else {
                manager.children.push(person);
            }
        }

        for (const person of people) {
            person.children.sort((a, b) => a.name.localeCompare(b.name));
        }
        roots.sort((a, b) => a.name.localeCompare(b.name));

        if (roots.length === 1) {
            return roots[0];
        }

        return {
            key: "__department_root__",
            name: "Department",
            managerKey: "",
            managerName: "",
            workType: "",
            location: "",
            presenceStatus: "",
            presenceText: `${roots.length} top-level leaders`,
            children: roots,
            synthetic: true
        };
    }

    private relationshipWouldCreateCycle(
        childKey: string,
        managerKey: string,
        byKey: Map<string, OrgPerson>
    ): boolean {
        const seen = new Set<string>([childKey]);
        let current = managerKey;

        while (current) {
            if (seen.has(current)) {
                return true;
            }
            seen.add(current);
            const person = byKey.get(current);
            if (!person) {
                return false;
            }
            current = person.managerKey;
        }
        return false;
    }

    private renderTree(fitAfterRender: boolean): void {
        if (!this.rootData) {
            this.renderMessage("No organization data.");
            return;
        }

        this.chartHost.replaceChildren();
        this.layoutByKey.clear();

        const width = Math.max(this.chartHost.clientWidth, 600);
        const height = Math.max(this.chartHost.clientHeight, 360);

        const svg = this.svgElement("svg");
        svg.setAttribute("width", "100%");
        svg.setAttribute("height", "100%");
        svg.setAttribute("viewBox", `0 0 ${width} ${height}`);
        svg.setAttribute("role", "tree");
        svg.setAttribute("aria-label", "Presence-aware organization chart");
        svg.classList.add("presence-org-chart__svg");
        this.currentSvg = svg;

        const viewport = this.svgElement("g");
        viewport.classList.add("presence-org-chart__viewport");
        svg.appendChild(viewport);
        this.viewport = viewport;

        let nextLeafX = 0;
        const rootLayout = this.layoutSubtree(this.rootData, 0, () => {
            const x = nextLeafX;
            nextLeafX += this.nodeWidth + this.horizontalGap;
            return x;
        });

        const flatNodes: LayoutNode[] = [];
        this.flattenLayout(rootLayout, flatNodes);
        this.currentLayoutNodes = flatNodes;
        for (const node of flatNodes) {
            if (!node.person.synthetic) {
                this.layoutByKey.set(node.person.key, node);
            }
        }

        for (const node of flatNodes) {
            for (const child of node.visibleChildren) {
                viewport.appendChild(this.createLink(node, child));
            }
        }

        for (const node of flatNodes) {
            viewport.appendChild(this.createNode(node));
        }

        this.attachPanAndZoom(svg);
        this.chartHost.appendChild(svg);

        if (fitAfterRender) {
            this.fitAll();
        } else {
            this.applyTransform();
        }
    }

    private layoutSubtree(person: OrgPerson, depth: number, nextLeafX: () => number): LayoutNode {
        const isCollapsed = !person.synthetic && this.collapsedKeys.has(person.key);
        const children = isCollapsed ? [] : person.children;
        const laidOutChildren = children.map(child => this.layoutSubtree(child, depth + 1, nextLeafX));

        let x: number;
        if (laidOutChildren.length === 0) {
            x = nextLeafX();
        } else {
            x = laidOutChildren.reduce((sum, child) => sum + child.x, 0) / laidOutChildren.length;
        }

        return {
            person,
            x,
            y: depth * (this.nodeHeight + this.verticalGap),
            depth,
            visibleChildren: laidOutChildren
        };
    }

    private flattenLayout(node: LayoutNode, output: LayoutNode[]): void {
        output.push(node);
        for (const child of node.visibleChildren) {
            this.flattenLayout(child, output);
        }
    }

    private createLink(source: LayoutNode, target: LayoutNode): SVGPathElement {
        const path = this.svgElement("path");
        const sourceY = source.y + this.nodeHeight / 2;
        const targetY = target.y - this.nodeHeight / 2;
        const midY = sourceY + (targetY - sourceY) / 2;

        path.setAttribute(
            "d",
            `M ${source.x} ${sourceY} C ${source.x} ${midY}, ${target.x} ${midY}, ${target.x} ${targetY}`
        );
        path.classList.add("presence-org-chart__link");
        return path;
    }

    private createNode(node: LayoutNode): SVGGElement {
        const group = this.svgElement("g");
        group.setAttribute("transform", `translate(${node.x}, ${node.y})`);
        group.classList.add("presence-org-chart__node");

        if (node.person.synthetic) {
            group.classList.add("presence-org-chart__node--synthetic");
        } else {
            group.dataset.key = node.person.key;
            group.setAttribute("tabindex", "0");
            group.setAttribute("role", "treeitem");
            group.setAttribute("aria-label", `${node.person.name}. ${node.person.presenceText}`);

            if (node.person.key === this.selectedEmployeeKey) {
                group.classList.add("presence-org-chart__node--selected");
            }

            const select = (): void => this.selectPerson(node.person);
            group.addEventListener("click", select);
            group.addEventListener("keydown", event => {
                if (event.key === "Enter" || event.key === " ") {
                    event.preventDefault();
                    select();
                }
            });
        }

        const card = this.svgElement("rect");
        card.setAttribute("x", String(-this.nodeWidth / 2));
        card.setAttribute("y", String(-this.nodeHeight / 2));
        card.setAttribute("width", String(this.nodeWidth));
        card.setAttribute("height", String(this.nodeHeight));
        card.setAttribute("rx", "10");
        card.classList.add("presence-org-chart__card");
        group.appendChild(card);

        const statusBar = this.svgElement("rect");
        statusBar.setAttribute("x", String(-this.nodeWidth / 2));
        statusBar.setAttribute("y", String(-this.nodeHeight / 2));
        statusBar.setAttribute("width", "7");
        statusBar.setAttribute("height", String(this.nodeHeight));
        statusBar.setAttribute("rx", "4");
        statusBar.setAttribute("fill", this.statusColor(node.person.presenceStatus));
        group.appendChild(statusBar);

        group.appendChild(
            this.svgText(node.person.name || "(Unnamed employee)", -this.nodeWidth / 2 + 18, -18, "presence-org-chart__name")
        );

        group.appendChild(
            this.svgText(
                node.person.presenceText || node.person.presenceStatus || "",
                -this.nodeWidth / 2 + 18,
                8,
                "presence-org-chart__presence"
            )
        );

        const reportCount = node.person.children.length;
        const detail = node.person.synthetic
            ? node.person.presenceText
            : reportCount === 0
                ? "Individual contributor"
                : `${reportCount} direct report${reportCount === 1 ? "" : "s"}`;

        group.appendChild(
            this.svgText(detail, -this.nodeWidth / 2 + 18, 32, "presence-org-chart__detail")
        );

        if (!node.person.synthetic && reportCount > 0) {
            const collapse = this.svgElement("g");
            collapse.classList.add("presence-org-chart__collapse");
            collapse.setAttribute("transform", `translate(${this.nodeWidth / 2 - 18}, ${this.nodeHeight / 2 - 18})`);
            collapse.setAttribute("role", "button");
            collapse.setAttribute("aria-label", this.collapsedKeys.has(node.person.key) ? "Expand branch" : "Collapse branch");

            const circle = this.svgElement("circle");
            circle.setAttribute("r", "11");
            circle.classList.add("presence-org-chart__collapse-circle");
            collapse.appendChild(circle);

            const symbol = this.svgText(this.collapsedKeys.has(node.person.key) ? "+" : "−", 0, 4, "presence-org-chart__collapse-symbol");
            symbol.setAttribute("text-anchor", "middle");
            collapse.appendChild(symbol);

            collapse.addEventListener("click", event => {
                event.stopPropagation();
                if (this.collapsedKeys.has(node.person.key)) {
                    this.collapsedKeys.delete(node.person.key);
                } else {
                    this.collapsedKeys.add(node.person.key);
                }
                this.renderTree(false);
            });
            group.appendChild(collapse);
        }

        return group;
    }

    private selectPerson(person: OrgPerson): void {
        this.selectedEmployeeKey = person.key;
        this.selectedEmployeeName = person.name;
        this.selectedPresenceText = person.presenceText;
        this.notifyOutputChanged();

        this.chartHost
            .querySelectorAll(".presence-org-chart__node--selected")
            .forEach(element => element.classList.remove("presence-org-chart__node--selected"));

        const selected = Array.from(this.chartHost.querySelectorAll<SVGGElement>(".presence-org-chart__node"))
            .find(element => element.dataset.key === person.key);
        selected?.classList.add("presence-org-chart__node--selected");
    }

    private searchEmployee(query: string): void {
        const normalized = query.trim().toLowerCase();
        if (!normalized) {
            return;
        }

        const match = this.people.find(person =>
            person.name.toLowerCase().includes(normalized) || person.key.includes(normalized)
        );

        if (!match) {
            this.searchInput.setCustomValidity("No matching employee found.");
            this.searchInput.reportValidity();
            return;
        }
        this.searchInput.setCustomValidity("");

        // Expand the entire manager chain so the found node is visible.
        const byKey = new Map(this.people.map(person => [person.key, person]));
        let managerKey = match.managerKey;
        while (managerKey) {
            this.collapsedKeys.delete(managerKey);
            managerKey = byKey.get(managerKey)?.managerKey || "";
        }

        this.selectPerson(match);
        this.renderTree(false);
        this.centerOnKey(match.key);
    }

    private centerOnKey(key: string): void {
        const node = this.layoutByKey.get(key);
        if (!node) {
            return;
        }

        const width = Math.max(this.chartHost.clientWidth, 600);
        const height = Math.max(this.chartHost.clientHeight, 360);
        this.tx = width / 2 - node.x * this.scale;
        this.ty = height / 2 - node.y * this.scale;
        this.applyTransform();
    }

    private fitAll(): void {
        if (!this.viewport || this.layoutByKey.size === 0) {
            return;
        }

        const nodes = this.currentLayoutNodes.length > 0
            ? this.currentLayoutNodes
            : Array.from(this.layoutByKey.values());

        const bounds: Bounds = {
            minX: Math.min(...nodes.map(n => n.x - this.nodeWidth / 2)),
            minY: Math.min(...nodes.map(n => n.y - this.nodeHeight / 2)),
            maxX: Math.max(...nodes.map(n => n.x + this.nodeWidth / 2)),
            maxY: Math.max(...nodes.map(n => n.y + this.nodeHeight / 2))
        };

        const width = Math.max(this.chartHost.clientWidth, 600);
        const height = Math.max(this.chartHost.clientHeight, 360);
        const contentWidth = Math.max(bounds.maxX - bounds.minX, this.nodeWidth);
        const contentHeight = Math.max(bounds.maxY - bounds.minY, this.nodeHeight);

        this.scale = this.clamp(
            Math.min((width - 60) / contentWidth, (height - 60) / contentHeight, 1),
            this.minScale,
            this.maxScale
        );

        const centerX = (bounds.minX + bounds.maxX) / 2;
        this.tx = width / 2 - centerX * this.scale;
        this.ty = 30 - bounds.minY * this.scale;
        this.applyTransform();
    }

    private zoomAtCenter(factor: number): void {
        if (!this.currentSvg) {
            return;
        }
        const width = Math.max(this.chartHost.clientWidth, 600);
        const height = Math.max(this.chartHost.clientHeight, 360);
        this.zoomAround(width / 2, height / 2, factor);
    }

    private attachPanAndZoom(svg: SVGSVGElement): void {
        let dragging = false;
        let lastX = 0;
        let lastY = 0;

        svg.addEventListener(
            "wheel",
            event => {
                event.preventDefault();
                const rect = svg.getBoundingClientRect();
                const pointerX = event.clientX - rect.left;
                const pointerY = event.clientY - rect.top;
                this.zoomAround(pointerX, pointerY, event.deltaY < 0 ? 1.12 : 0.89);
            },
            { passive: false }
        );

        svg.addEventListener("pointerdown", event => {
            // Let clicks on a node/collapse button continue to work; a drag only
            // becomes visible after pointermove changes the transform.
            dragging = true;
            lastX = event.clientX;
            lastY = event.clientY;
            svg.setPointerCapture(event.pointerId);
            svg.classList.add("presence-org-chart__svg--dragging");
        });

        svg.addEventListener("pointermove", event => {
            if (!dragging) {
                return;
            }
            this.tx += event.clientX - lastX;
            this.ty += event.clientY - lastY;
            lastX = event.clientX;
            lastY = event.clientY;
            this.applyTransform();
        });

        const stopDragging = (event: PointerEvent): void => {
            dragging = false;
            if (svg.hasPointerCapture(event.pointerId)) {
                svg.releasePointerCapture(event.pointerId);
            }
            svg.classList.remove("presence-org-chart__svg--dragging");
        };

        svg.addEventListener("pointerup", stopDragging);
        svg.addEventListener("pointercancel", stopDragging);
    }

    private zoomAround(x: number, y: number, factor: number): void {
        const oldScale = this.scale;
        const newScale = this.clamp(oldScale * factor, this.minScale, this.maxScale);
        this.tx = x - ((x - this.tx) / oldScale) * newScale;
        this.ty = y - ((y - this.ty) / oldScale) * newScale;
        this.scale = newScale;
        this.applyTransform();
    }

    private applyTransform(): void {
        this.viewport?.setAttribute("transform", `translate(${this.tx}, ${this.ty}) scale(${this.scale})`);
    }

    private updateStatusSummary(): void {
        if (!this.statusSummary) {
            return;
        }

        const counts = new Map<string, number>();
        for (const person of this.people) {
            counts.set(person.presenceStatus, (counts.get(person.presenceStatus) || 0) + 1);
        }

        const parts = [
            `In person ${counts.get("In-Person") || 0}`,
            `Remote ${counts.get("Remote") || 0}`,
            `Vacation ${counts.get("Vacation") || 0}`,
            `Sick ${counts.get("Sick") || 0}`,
            `Holiday ${counts.get("Holiday") || 0}`
        ];

        const missing = counts.get("Location Missing") || 0;
        if (missing > 0) {
            parts.push(`Missing location ${missing}`);
        }

        this.statusSummary.textContent = parts.join(" · ");
    }

    private statusColor(status: string): string {
        switch (status) {
            case "In-Person":
                return "#107C10";
            case "Remote":
                return "#0078D4";
            case "Vacation":
                return "#8764B8";
            case "Sick":
                return "#D83B01";
            case "Holiday":
                return "#5C2D91";
            case "Location Missing":
                return "#A4262C";
            default:
                return "#605E5C";
        }
    }

    private renderMessage(message: string): void {
        this.chartHost.replaceChildren();
        this.currentSvg = undefined;
        this.viewport = undefined;
        const div = document.createElement("div");
        div.className = "presence-org-chart__message";
        div.textContent = message;
        this.chartHost.appendChild(div);
    }

    private svgText(value: string, x: number, y: number, className: string): SVGTextElement {
        const element = this.svgElement("text");
        element.setAttribute("x", String(x));
        element.setAttribute("y", String(y));
        element.classList.add(className);
        element.textContent = this.truncate(value, 32);
        return element;
    }

    private truncate(value: string, maxLength: number): string {
        return value.length <= maxLength ? value : `${value.slice(0, maxLength - 1)}…`;
    }

    private clamp(value: number, min: number, max: number): number {
        return Math.min(max, Math.max(min, value));
    }

    private svgElement<K extends keyof SVGElementTagNameMap>(tagName: K): SVGElementTagNameMap[K] {
        return document.createElementNS("http://www.w3.org/2000/svg", tagName);
    }
}
