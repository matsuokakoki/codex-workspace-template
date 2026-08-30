# Pre-download manifest

Use this only for known **public static inputs** that should exist before Codex starts.

Format:

```json
[
  {
    "url": "https://example.com/data.zip",
    "path": "data/raw/data.zip",
    "sha256": ""
  }
]
```

- `url`: source URL
- `path`: repository-relative destination
- `sha256`: optional expected SHA-256

Do not place passwords, API keys, signed private URLs, or other secrets here.
