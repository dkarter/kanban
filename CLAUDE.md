# CLAUDE.md - Kanban Project Guidelines

## Development Commands

- `task app:setup` - Run setup from root directory
- `task app:deps:get` - Download dependencies
- `task ci:run` - Run full CI pipeline locally
- `task ci:lint:elixir` - Run Elixir linter
- `task ci:format:check` - Check formatting
- `task ci:test` - Run tests with fail-fast
- `task docker:compose:web:up` - Run app with Docker Compose

### Commands in app/ directory

- `cd app && mix setup` - Install and setup dependencies
- `cd app && mix phx.server` - Start Phoenix server
- `cd app && iex -S mix phx.server` - Start with IEx console
- `cd app && mix test` - Run all tests
- `cd app && mix test test/path/to/test_file.exs` - Run specific test file
- `cd app && mix test test/path/to/test_file.exs:line_number` - Run specific test

## Code Style Guidelines

- **Formatting**: Use `mix format` for consistent code style
- **Documentation**: Modules and public functions must have @moduledoc and @doc
- **Naming**: Use snake_case for variables/functions, CamelCase for modules
- **Module Structure**: Group functions by type (callbacks, public API, private)
- **Imports**: Prefer explicit imports, avoid `import Foo, only: :all`
- **Error Handling**: Use `with` statements for multiple operations that can fail
- **Types**: Leverage typespecs for function definitions
- **Context Organization**: Follow Phoenix contexts pattern for business logic
- **Testing**: Test public API of modules, not implementation details
- **Git**: Make small atomic commits at each logical chunk of functionality, and use feature branches. Commits should follow conventional commits.

