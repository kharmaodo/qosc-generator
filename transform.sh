#!/bin/bash

# Script de transformation XSLT pour générer des rapports HTML à partir des XML d'audit.

# Vérifie si xsltproc est disponible
if ! command -v xsltproc &> /dev/null
then
    echo "Erreur: xsltproc n'est pas installé ou n'est pas dans le PATH."
    echo "Ce script nécessite l'outil xsltproc pour les transformations XSLT."
    echo "Veuillez l'installer ou utiliser un autre outil de transformation XSLT."
    exit 1
fi

echo "Début de la transformation des rapports XML en HTML..."
OUTPUT_DIR="target/html-reports"
mkdir -p "$OUTPUT_DIR"

# 1. Transformation Checkstyle
CHECKSTYLE_XML="target/checkstyle-result.xml"
CHECKSTYLE_XSL="checkstyle.xsl"
CHECKSTYLE_HTML="$OUTPUT_DIR/checkstyle-report.html"

if [ -f "$CHECKSTYLE_XML" ]; then
    echo "Transformation de $CHECKSTYLE_XML..."
    xsltproc "$CHECKSTYLE_XSL" "$CHECKSTYLE_XML" > "$CHECKSTYLE_HTML"
    echo "Rapport Checkstyle généré: $CHECKSTYLE_HTML"
else
    echo "Avertissement: $CHECKSTYLE_XML non trouvé. Assurez-vous d'avoir exécuté 'mvn clean install'."
fi

# 2. Transformation SpotBugs
SPOTBUGS_XML="target/spotbugsXml.xml"
SPOTBUGS_XSL="spotbugs-html.xsl"
SPOTBUGS_HTML="$OUTPUT_DIR/spotbugs-report.html"

if [ -f "$SPOTBUGS_XML" ]; then
    echo "Transformation de $SPOTBUGS_XML..."
    xsltproc "$SPOTBUGS_XSL" "$SPOTBUGS_XML" > "$SPOTBUGS_HTML"
    echo "Rapport SpotBugs généré: $SPOTBUGS_HTML"
else
    echo "Avertissement: $SPOTBUGS_XML non trouvé. Assurez-vous d'avoir exécuté 'mvn clean install'."
fi

echo "Transformation terminée. Vérifiez le répertoire $OUTPUT_DIR"