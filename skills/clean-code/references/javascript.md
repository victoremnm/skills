# JavaScript and TypeScript clean-code reference

Use this reference for JavaScript and TypeScript code. Follow the repository's
runtime, module system, type settings, formatter, and framework conventions.

## Names and functions

- Use meaningful names and consistent domain vocabulary. Name constants and
  units explicitly; avoid magic values and one-letter variables outside tiny,
  obvious scopes.
- Keep functions focused and at one level of abstraction. Prefer two or fewer
  meaningful parameters; use a named options object when several values form a
  concept, with a clear type or documented contract.
- Avoid boolean flags that select unrelated behavior. Split the behaviors or
  make the strategy explicit.
- Prefer pure transformations where practical. Keep mutation, DOM work, I/O,
  storage, and network effects at visible boundaries.

Bad:

```javascript
function process(items, doubleItems = false) {
  return doubleItems ? items.map(item => item * 2) : items;
}
```

Good:

```javascript
const doubleItems = items => items.map(item => item * 2);
const keepItems = items => items;
```

## Objects, modules, and classes

- Keep data structures and behavior coherent. Encapsulate invariants instead of
  exposing fields that any caller can put into an invalid state.
- Prefer small functions and composition over classes when state or identity is
  not needed. Use ES2015+ classes when a real object lifecycle or subtype
  contract justifies them; avoid inheritance chains by default.
- Keep modules cohesive and dependencies explicit. Avoid circular dependencies,
  broad utility modules, and imports that hide expensive or effectful work.
- In TypeScript, make public contracts precise and do not use `any` to silence a
  design problem. Use narrow unions, interfaces, or domain types where they
  improve callers' understanding.

Bad:

```typescript
function createUser(data: any) {
  return { name: data.name, role: data.role };
}
```

Good:

```typescript
type UserInput = { name: string; role: "admin" | "member" };

function createUser(data: UserInput) {
  return { name: data.name, role: data.role };
}
```

## Async and errors

- Prefer promises and `async`/`await` over nested callbacks. Handle rejected
  promises at a boundary that can recover, report, or translate the failure.
- Do not ignore caught errors or replace useful context with generic logging.
  Preserve causes and actionable metadata where the runtime supports it.
- Make concurrency behavior explicit: cancellation, ordering, retries, shared
  state, and cleanup should be understandable from the boundary API.
- Avoid accidental sequential waits or unbounded parallelism; choose based on
  dependency and resource constraints, not stylistic preference.

Bad:

```javascript
async function loadUsers(ids) {
  const users = [];
  for (const id of ids) {
    users.push(await fetchUser(id));
  }
  return users;
}
```

Good:

```javascript
async function loadUsers(ids) {
  return Promise.all(ids.map(fetchUser));
}
```

## Testing, formatting, and comments

- Test behavior at module boundaries and isolate external systems behind
  testable adapters. Add regression tests before risky refactors.
- Follow the repository's Prettier, ESLint, TypeScript, and test configuration.
  Formatting consistency is useful; do not present formatter preferences as
  architectural findings.
- Comment intent, invariants, compatibility constraints, or surprising runtime
  behavior. Remove comments that merely repeat the code.

Bad:

```javascript
// Increment i by 1.
i += 1;
```

Good:

```javascript
// Keep the retry budget bounded to avoid a retry storm.
retryCount += 1;
```

Source: [clean-code-javascript](https://github.com/ryanmcdermott/clean-code-javascript).
