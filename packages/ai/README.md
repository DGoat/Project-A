# AI Package

Reusable AI infrastructure should live here.

## Planned Modules

- provider interface
- mock provider
- openai-compatible provider
- local LLM provider
- replay provider
- prompt loader
- response validation

## Target Provider Interface

```ts
interface AIProvider {
  chat(input: ChatInput): Promise<ChatOutput>
  embed?(input: EmbedInput): Promise<EmbedOutput>
}
```
