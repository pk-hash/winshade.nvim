# Winshade Tests

Automated tests for winshade.nvim using [plenary.nvim](https://github.com/nvim-lua/plenary.nvim).

## Prerequisites

Install plenary.nvim:

```lua
-- Using lazy.nvim
{
  "nvim-lua/plenary.nvim"
}
```

## Running Tests

### Using Make (recommended)

```bash
make test
```

### Using the test script directly

```bash
./tests/run_tests.sh
```

### Using Neovim directly

```bash
nvim --headless -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }"
```

## Test Coverage

Current tests cover:

- **Setup**: Configuration initialization and options
- **Enable/Disable**: Plugin state management
- **Config**: Option merging and window exclusion logic
- **Highlight**: Basic highlight operations and error handling

## Writing Tests

Tests are written using plenary's busted-style testing framework:

```lua
describe("feature", function()
  it("does something", function()
    assert.equals(expected, actual)
  end)
end)
```

See `tests/winshade_spec.lua` for examples.

## Test Structure

```
tests/
├── winshade_spec.lua    # Main test suite
├── minimal_init.lua     # Minimal Neovim config for testing
├── run_tests.sh         # Test runner script
└── README.md            # This file
```
