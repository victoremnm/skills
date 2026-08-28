# Python clean-code reference

Use this reference for Python code. Prefer the project's supported Python
version and configured tools over generic rules.

## Names and boundaries

- Use meaningful `snake_case` names and consistent domain vocabulary.
- Name constants and units explicitly; replace magic numbers with searchable
  constants or domain objects.
- Keep functions small and focused. Prefer two or fewer meaningful arguments;
  use a dataclass or typed structure when several values form one concept.
- Use keyword arguments when they clarify call sites, and default parameters
  for genuine defaults rather than conditional reassignment.
- Split filtering, transformation, I/O, and orchestration when they are separate
  responsibilities. Keep each function at one level of abstraction.

Bad:

```python
def process(items, flag=False):
    return [item * 2 for item in items] if flag else list(items)
```

Good:

```python
def double_items(items: list[int]) -> list[int]:
    return [item * 2 for item in items]


def keep_items(items: list[int]) -> list[int]:
    return list(items)
```

## Python-specific design

- Add or preserve useful type annotations. Use precise domain types instead of
  broad `Any`, untyped dictionaries, or misleading annotations.
- Use dataclasses, `TypedDict`, `Protocol`, or small value objects when they make
  a data contract clearer; do not wrap every dictionary or function in a class.
- Prefer iteration and generators for streaming work when eager materialization
  is unnecessary. Do not trade away clarity for a micro-optimization.
- Avoid mutable default arguments, hidden module state, and in-place mutation
  that callers cannot see. Use `default_factory` for mutable dataclass fields.
- Keep I/O, network calls, persistence, logging, and other side effects at clear
  boundaries. Pass dependencies in when that makes behavior easier to test.
- Catch exceptions at a boundary that can recover, translate, or add useful
  context. Do not catch broadly and silently continue; preserve exception causes
  when raising a domain error.

Bad:

```python
def load_user(user_id):
    try:
        return repository.fetch(user_id)
    except Exception:
        return None
```

Good:

```python
def load_user(user_id: int) -> User:
    try:
        return repository.fetch(user_id)
    except UserNotFoundError:
        raise
    except RepositoryError as error:
        raise UserLoadError(user_id) from error
```

## Classes and abstractions

- Give a class one cohesive reason to change. Separate data acquisition,
  rendering, persistence, and policy when they change independently.
- Preserve the behavioral contract of base classes and protocols. Do not narrow
  accepted inputs or change return/error behavior in a subtype.
- Prefer small composable protocols or ABCs over comprehensive interfaces with
  methods consumers do not need. Prefer composition when inheritance adds
  coupling without a genuine subtype relationship.

Bad:

```python
class ReportService:
    def build(self, rows):
        return "\\n".join(str(row) for row in rows)

    def save(self, rows, path):
        Path(path).write_text(self.build(rows))
```

Good:

```python
def render_report(rows) -> str:
    return "\\n".join(str(row) for row in rows)


def save_report(content: str, path: Path) -> None:
    path.write_text(content)
```

## Verification

Recommend focused tests for extracted functions, boundary conditions, exception
translation, and side-effect adapters. Keep refactors behavior-preserving unless
the user explicitly requests a behavior change. Run the repository's configured
formatter, linter, type checker, and test commands when available.

Source: [clean-code-python](https://github.com/zedr/clean-code-python).
