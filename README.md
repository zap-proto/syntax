# ZAP Protocol Syntax Highlighting

> **Docs:** [ZAP schema syntax highlighting](https://zap-proto.dev/docs/sdks) · part of the [ZAP Protocol](https://zap-proto.io)


Official syntax highlighting for ZAP (Zero-copy Application Protocol) schema files.

## Features

- Full TextMate grammar for `.zap` and `.zaps` files
- Compatible with Shiki, VS Code, Monaco, and TextMate-based editors
- Highlights:
  - Structs, enums, interfaces, services
  - Field IDs (`@0`, `@1`, etc.)
  - Unique IDs (`@0xdbb9ad1f14bf0b36`)
  - Primitive types (`Int32`, `Float64`, `Text`, etc.)
  - Short aliases (`i32`, `f64`, `bool`, etc.)
  - Composite types (`List`, `Map`, `Option`, `Result`)
  - Comments (`#`, `//`, `/* */`)
  - Strings (double, single, backtick)
  - Numbers (decimal, hex, binary, octal, float)
  - Annotations and modifiers
  - RPC definitions

## Installation

### npm / pnpm / yarn

```bash
npm install zap-syntax
pnpm add zap-syntax
yarn add zap-syntax
```

### VS Code

Search for "ZAP Protocol" in the VS Code extensions marketplace, or:

```bash
code --install-extension zap-protocol.zap-syntax
```

## Usage

### Shiki (Recommended for Web)

```typescript
import { createHighlighter } from 'shiki';
import { registerZapLanguage } from 'zap-syntax';

const highlighter = await createHighlighter({
  themes: ['github-dark', 'github-light'],
  langs: [],
});

// Register ZAP language
await registerZapLanguage(highlighter);

// Highlight code
const html = highlighter.codeToHtml(`
struct Point @0 {
  x @0 :Float64;
  y @1 :Float64;
}
`, {
  lang: 'zap',
  theme: 'github-dark'
});
```

### Shiki with Bundled Langs

```typescript
import { createHighlighter } from 'shiki';
import zapGrammar from 'zap-syntax/grammar';

const highlighter = await createHighlighter({
  themes: ['github-dark'],
  langs: [
    {
      name: 'zap',
      scopeName: 'source.zap',
      ...zapGrammar
    }
  ],
});
```

### Fumadocs (Next.js)

Add to your `source.config.ts`:

```typescript
import { rehypeCode } from 'fumadocs-core/mdx-plugins';
import zapGrammar from 'zap-syntax/grammar';

export default {
  mdxOptions: {
    rehypePlugins: [
      [rehypeCode, {
        langs: [zapGrammar]
      }]
    ]
  }
};
```

Or in your shiki configuration:

```typescript
// lib/shiki.ts
import { createHighlighter } from 'shiki';
import { getZapGrammar } from 'zap-syntax';

export async function getHighlighter() {
  const highlighter = await createHighlighter({
    themes: ['github-dark-dimmed'],
    langs: ['typescript', 'go', 'rust', getZapGrammar()],
  });
  return highlighter;
}
```

### Monaco Editor

```typescript
import * as monaco from 'monaco-editor';
import zapGrammar from 'zap-syntax/grammar';

monaco.languages.register({ id: 'zap', extensions: ['.zap', '.zaps'] });

// Use with monaco-textmate or monaco-vscode-textmate-theme-converter
```

## Schema Example

```zap
# ZAP Protocol Schema
@0xdbb9ad1f14bf0b36;

struct Message @0 {
  id @0 :UInt64;
  timestamp @1 :Int64;
  payload @2 :Data;
  metadata @3 :Map(Text, Text);
}

enum Status @1 {
  pending @0;
  success @1;
  error @2;
}

interface Calculator @2 {
  add @0 (a :Float64, b :Float64) -> (result :Float64);
  multiply @1 (a :Float64, b :Float64) -> (result :Float64);
}

service MathService @3 {
  rpc Calculate (Request) returns (Response);
  rpc Stream (stream Request) returns (stream Response);
}
```

## Scopes

The grammar provides the following TextMate scopes:

| Scope | Description |
|-------|-------------|
| `keyword.control.zap` | struct, enum, interface, union, service |
| `keyword.other.zap` | import, using, const, extends |
| `keyword.modifier.zap` | inline, packed, aligned, optional |
| `storage.type.primitive.zap` | Int32, Float64, Text, Bool, etc. |
| `storage.type.composite.zap` | List, Map, Set, Option, Result |
| `entity.name.type.zap` | User-defined types |
| `constant.numeric.field-id.zap` | @0, @1, @2, etc. |
| `keyword.other.unique-id.zap` | @0xdbb9ad1f14bf0b36 |
| `comment.line.number-sign.zap` | # comments |
| `string.quoted.double.zap` | "strings" |
| `constant.numeric.*.zap` | Numbers (int, float, hex, etc.) |

## API

### Functions

- `getZapGrammar()` - Returns the TextMate grammar object
- `registerZapLanguage(highlighter)` - Registers ZAP with a Shiki highlighter

### Exports

- `zapGrammar` - The raw TextMate grammar JSON
- `zapLanguageConfiguration` - VS Code language configuration
- `zapLanguage` - Shiki language definition object

## Development

```bash
# Clone
git clone https://github.com/zap-protocol/syntax.git
cd syntax

# Install
pnpm install

# Build
pnpm build

# Test highlighting
pnpm test
```

## Quick Fallback

While setting up custom Shiki integration, you can use `proto` as a language alias since ZAP's schema syntax is similar to Protocol Buffers:

```markdown
\`\`\`proto
struct Message @0 {
  id @0 :UInt64;
  payload @1 :Data;
}
\`\`\`
```

This provides basic syntax highlighting until full ZAP language support is configured.

## Related

- [ZAP Protocol](https://zap-protocol.github.io) - Official documentation
- [zap-protocol/zap](https://github.com/zap-protocol/zap) - Core implementation
- [zap-protocol/benchmarks](https://github.com/zap-protocol/benchmarks) - Performance benchmarks

## License

MIT License - see [LICENSE](LICENSE)

---

**ZAP Protocol** — Infinitely faster. Zero-copy Application Protocol for the age of AI & crypto.