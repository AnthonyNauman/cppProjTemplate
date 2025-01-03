#!/bin/bash

source $(dirname $0)/project_info.sh

DOCS_DIR=$PROJ_DIR/documentation
DOXYFILE=$DOCS_DIR/Doxyfile
DOXYGEN_FLAT_SRC=devops/docs/doxygenFlatTheme/src

rm $DOXYFILE
rm $DOCS_DIR
mkdir -p $DOCS_DIR

# generating default Doxyfile
doxygen -g $DOXYFILE

PROJECT_NAME=$PROJ_NAME
PROJECT_NUMBER=$PROJ_VERSION
PROJECT_BRIEF="Brief description of project"
PROJECT_LOGO=""
OUTPUT_DIRECTORY="$DOCS_DIR"
INPUT="$PROJ_DIR/apps/app"
CREATE_SUBDIRS="NO"
ALLOW_UNICODE_NAMES="NO"
OUTPUT_LANGUAGE="English"
OUTPUT_TEXT_DIRECTION="None"
BRIEF_MEMBER_DESC="YES"
REPEAT_BRIEF="YES"
RECURSIVE="YES"
GENERATE_HTML="YES"
GENERATE_LATEX="NO"
USE_MDFILE_AS_MAINPAGE="README.md"
HTML_EXTRA_STYLESHEET="devops/docs/doxygenFlatTheme/src/doxygen-style.css"
# HTML_EXTRA_STYLESHEET="devops/docs/doxygenDarkTheme/custom_dark_theme.css"
# HTML_EXTRA_STYLESHEET+=" devops/docs/doxygenDarkTheme/custom.css"
HTML_FOOTER="devops/docs/doxygenDarkTheme/html_footer.html"
HTML_HEADER="devops/docs/doxygenDarkTheme/html_header.html"

HTML_EXTRA_FILES="devops/docs/doxygenFlatTheme/src/img/closed-folder.png "
HTML_EXTRA_FILES+=" devops/docs/doxygenFlatTheme/src/img/closed-folder.png"
HTML_EXTRA_FILES+=" devops/docs/doxygenFlatTheme/src/img/document.png"
HTML_EXTRA_FILES+=" devops/docs/doxygenFlatTheme/src/img/off_sync.png"
HTML_EXTRA_FILES+=" devops/docs/doxygenFlatTheme/src/img/on_sync.png"
HTML_EXTRA_FILES+=" devops/docs/doxygenFlatTheme/src/img/opened-folder.png"

# Change default values in Doxyfile
sed -i "s/^PROJECT_NAME *=.*/PROJECT_NAME = $PROJECT_NAME/" "$DOXYFILE"
sed -i "s|^PROJECT_NUMBER *=.*|PROJECT_NUMBER = $PROJECT_NUMBER|" "$DOXYFILE"
sed -i "s|^PROJECT_BRIEF *=.*|PROJECT_BRIEF = $PROJECT_BRIEF|" "$DOXYFILE"
# sed -i "s|^PROJECT_LOGO *=.*|PROJECT_LOGO = $PROJECT_LOGO|" "$DOXYFILE"
sed -i "s|^OUTPUT_DIRECTORY *=.*|OUTPUT_DIRECTORY = $OUTPUT_DIRECTORY|" "$DOXYFILE"
sed -i "s|^INPUT *=.*|INPUT = $INPUT README.md|" "$DOXYFILE"
# sed -i "s|^CREATE_SUBDIRS *=.*|CREATE_SUBDIRS = $CREATE_SUBDIRS|" "$DOXYFILE"
# sed -i "s|^ALLOW_UNICODE_NAMES *=.*|ALLOW_UNICODE_NAMES = $ALLOW_UNICODE_NAMES|" "$DOXYFILE"
# sed -i "s|^OUTPUT_LANGUAGE *=.*|OUTPUT_LANGUAGE = $OUTPUT_LANGUAGE|" "$DOXYFILE"
# sed -i "s|^OUTPUT_TEXT_DIRECTION *=.*|OUTPUT_TEXT_DIRECTION = $OUTPUT_TEXT_DIRECTION|" "$DOXYFILE"
# sed -i "s|^BRIEF_MEMBER_DESC *=.*|BRIEF_MEMBER_DESC = $BRIEF_MEMBER_DESC|" "$DOXYFILE"
# sed -i "s|^REPEAT_BRIEF *=.*|REPEAT_BRIEF = $REPEAT_BRIEF|" "$DOXYFILE"
sed -i "s|^RECURSIVE *=.*|RECURSIVE = $RECURSIVE|" "$DOXYFILE"
sed -i "s/^GENERATE_HTML *=.*/GENERATE_HTML = $GENERATE_HTML/" "$DOXYFILE"
sed -i "s/^GENERATE_LATEX *=.*/GENERATE_LATEX = $GENERATE_LATEX/" "$DOXYFILE"
sed -i "s/^USE_MDFILE_AS_MAINPAGE *=.*/USE_MDFILE_AS_MAINPAGE = $USE_MDFILE_AS_MAINPAGE/" "$DOXYFILE"
sed -i "s|^HTML_EXTRA_STYLESHEET *=.*|HTML_EXTRA_STYLESHEET = $HTML_EXTRA_STYLESHEET|" "$DOXYFILE"
sed -i "s|^HTML_EXTRA_FILES *=.*|HTML_EXTRA_FILES = $HTML_EXTRA_FILES|" "$DOXYFILE"
sed -i "s|^HTML_FOOTER *=.*|HTML_FOOTER = $HTML_FOOTER|" "$DOXYFILE"
# sed -i "s|^HTML_HEADER *=.*|HTML_HEADER = $HTML_HEADER|" "$DOXYFILE"

# generate docs
doxygen $DOXYFILE