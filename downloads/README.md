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

`path` must stay within this repository and cannot traverse through a symlink/reparse point. Only HTTPS URLs are accepted. A SHA-256 value, when supplied, must be 64 hexadecimal characters. Download content and reuse rights still require a human review.

Do not place passwords, API keys, signed private URLs, or other secrets here.
