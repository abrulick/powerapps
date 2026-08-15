# Helper Scripts

These scripts are optional conveniences. Read the implementation guide before executing them.

## Create PCF scaffold and apply this package's source

```powershell
.\Scripts\01-Create-PCF-Project.ps1 -TargetRoot "C:\repos\PresenceOrgChart"
```

Then:

```powershell
cd C:\repos\PresenceOrgChart
npm run build
```

## Create and build a solution project

```powershell
.\Scripts\02-Build-Solution.ps1 `
  -PcfProjectRoot "C:\repos\PresenceOrgChart" `
  -SolutionRoot "C:\repos\PresenceOrgChartSolution" `
  -PublisherName "YourPublisher" `
  -PublisherPrefix "yourprefix"
```

Use publisher values that match your organization's ALM standards.
