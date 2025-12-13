# PlantUML Feature

This feature installs PlantUML with Java runtime support.

## Usage

```json
{
    "features": {
        "./features/plantuml": {
            "version": "latest"
        }
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select the version of PlantUML to install | string | latest |

## Example Usage

```json
{
    "features": {
        "./features/plantuml": {}
    }
}
```

Or with a specific version:

```json
{
    "features": {
        "./features/plantuml": {
            "version": "1.2024.0"
        }
    }
}
```

## What it installs

- Java Runtime Environment (if not already present)
- PlantUML JAR file
- PlantUML wrapper script at `/usr/local/bin/plantuml`

## Commands

After installation, you can use PlantUML from the command line:

```bash
plantuml diagram.puml
plantuml -tsvg diagram.puml
plantuml -tpng diagram.puml
```
