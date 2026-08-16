# Power BI Queries

Create these Power Query queries:

1. `pMailbox` -> paste `pMailbox.m`
2. `pFolderPath` -> paste `pFolderPath.m`
3. `CRM_BaseMail` -> paste `CRM_BaseMail.m`
4. fact queries

The shared mailbox protocol embeds Base64 JSON between:
- `CRMJSON64:`
- `:ENDCRMJSON64`

`CRM_BaseMail` extracts and decodes that payload.

If your Exchange connector exposes Body in a slightly different record shape, adjust only the `BodyText` step; all downstream fact queries can remain unchanged.
