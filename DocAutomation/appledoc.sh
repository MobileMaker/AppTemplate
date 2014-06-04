DOCS_DIR="${PROJECT_DIR}/${PROJECT_NAME} AppleDoc"

if [ -d "$DOCS_DIR" ]; then
    echo "Cleaning documentation directory"
    rm -rf "$DOCS_DIR"/*
fi

./DocAutomation/appledoc_internal.sh "${PROJECT_DIR}" "$DOCS_DIR" "${PROJECT_NAME}" "Template" "com.app"
