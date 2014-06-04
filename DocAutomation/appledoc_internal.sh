# http://www.cocoanetics.com/2011/11/amazing-apple-like-documentation/

INPUT_ARGUMENTS_COUNT="$#"

CURRENT_DIR="`pwd`"

# Check input arguments
if [ $INPUT_ARGUMENTS_COUNT -lt "5" ]; then
    echo "Not all arguments supplied: usage <project directory path> <documentation directory path> <project name> <company name> <company id>"
fi

if [ $INPUT_ARGUMENTS_COUNT -eq "1" ]; then
    PROJECT_DIR="$1"
    DOCUMENTATION_DIR="$PROJECT_DIR/PROJECT_NAME AppleDoc"
    PROJECT_NAME="PROJECT_NAME"
    COMPANY_NAME="COMPANY_NAME"
    COMPANY_ID="COMPANY_ID"
fi
if [ $INPUT_ARGUMENTS_COUNT -eq "2" ]; then
    PROJECT_DIR="$1"
    DOCUMENTATION_DIR="$2"
    PROJECT_NAME="PROJECT_NAME"
    COMPANY_NAME="COMPANY_NAME"
    COMPANY_ID="COMPANY_ID"
fi
if [ $INPUT_ARGUMENTS_COUNT -eq "3" ]; then
    PROJECT_DIR="$1"
    DOCUMENTATION_DIR="$2"
    PROJECT_NAME="$3"
    COMPANY_NAME="COMPANY_NAME"
    COMPANY_ID="COMPANY_ID"
fi
if [ $INPUT_ARGUMENTS_COUNT -eq "4" ]; then
    PROJECT_DIR="$1"
    DOCUMENTATION_DIR="$2"
    PROJECT_NAME="$3"
    COMPANY_NAME="$4"
    COMPANY_ID="COMPANY_ID"
fi
if [ $INPUT_ARGUMENTS_COUNT -eq "5" ]; then
    PROJECT_DIR="$1"
    DOCUMENTATION_DIR="$2"
    PROJECT_NAME="$3"
    COMPANY_NAME="$4"
    COMPANY_ID="$5"
fi

# Print usefull information
echo "Generating AppleDoc documentation from '$PROJECT_DIR' for '$PROJECT_NAME' ('$COMPANY_NAME'; $COMPANY_ID) to '$DOCUMENTATION_DIR'"

#--docset-platform-family "macosx" \
#--ignore "*.m" \
#--keep-undocumented-objects \
#--keep-undocumented-members \

/usr/local/bin/appledoc \
--project-name "$PROJECT_NAME" \
--project-company "$COMPANY_NAME" \
--company-id "$COMPANY_ID" \
--output "$DOCUMENTATION_DIR" \
--explicit-crossref \
--keep-intermediate-files \
--logformat xcode \
--create-html \
--no-repeat-first-par \
--no-warn-missing-arg \
--no-warn-invalid-crossref \
--no-warn-undocumented-object \
--no-warn-undocumented-member \
--no-warn-empty-description \
--docset-platform-family "iOS" \
--index-desc "readme.markdown" \
--docset-bundle-id "$COMPANY_ID" \
--docset-bundle-name "$PROJECT_NAME" \
--docset-atom-filename "$PROJECT_NAME.atom" \
--docset-feed-url "http://app.com/$PROJECT_NAME/%DOCSETATOMFILENAME" \
--docset-package-url "http://app.com/$PROJECT_NAME/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "http://app.com/$PROJECT_NAME/" \
--publish-docset \
--exit-threshold 2 \
"$PROJECT_DIR"

# Create and validate apple docset indexes
#/Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil index -verbose -debug "$DOCUMENTATION_DIR/docset/Contents"
#/Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil validate -verbose -debug "$DOCUMENTATION_DIR/docset/Contents"
