#!/bin/bash

set -e

# Ensure we have required tools and font libraries
apt-get update
apt-get install -y wget curl libfreetype6 fontconfig jq

# Java should already be installed by the Java feature dependency
if ! command -v java &> /dev/null; then
    echo "Error: Java is required but not found. Make sure the Java feature is installed."
    exit 1
fi

# Set version
VERSION=${VERSION:-"latest"}

# Download PlantUML JAR
echo "Installing PlantUML ${VERSION}..."

if [ "${VERSION}" = "latest" ]; then
    # Get the latest release URL from GitHub API using jq to find plantuml.jar
    PLANTUML_URL=$(curl -s https://api.github.com/repos/plantuml/plantuml/releases/latest | jq -r '.assets[] | select(.name == "plantuml.jar") | .browser_download_url')
else
    PLANTUML_URL="https://github.com/plantuml/plantuml/releases/download/v${VERSION}/plantuml-${VERSION}.jar"
fi

# Download PlantUML JAR
wget -O /usr/local/bin/plantuml.jar "${PLANTUML_URL}"

# Create wrapper script
cat > /usr/local/bin/plantuml << 'EOF'
#!/bin/bash
java -Djava.awt.headless=true -jar /usr/local/bin/plantuml.jar "$@"
EOF

# Make script executable
chmod +x /usr/local/bin/plantuml

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "PlantUML ${VERSION} installation completed!"
echo "Usage: plantuml [options] file1 [file2] [file3]"
