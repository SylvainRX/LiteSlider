#!/bin/bash

# Exit immediately if any command fails
set -e

# Generate the documentation
xcrun docc process-archive \
  transform-for-static-hosting ./LiteSlider.doccarchive \
  --output-path ./docs \
  --hosting-base-path LiteSlider

# Overwrite index.html with the redirect
cat > ./docs/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="refresh" content="0; url=/LiteSlider/documentation/liteslider/">
        <title>Redirecting...</title>
    </head>
    <body>
        <p>If you are not redirected automatically, <a href="/LiteSlider/documentation/liteslider/">click here</a>.</p>
    </body>
</html>
EOF

echo "Documentation generated and index.html overwritten successfully."

