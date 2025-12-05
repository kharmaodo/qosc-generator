<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/checkstyle">
<html lang="fr">
<head>
    <meta charset="UTF-8"/>
    <title>Rapport Checkstyle - Audit QOSC (05/12/2025)</title>
    <style>
        body {font-family: Arial, sans-serif; margin:40px; background:#f9f9f9; color:#333;}
        h1 {color:#d32f2f; text-align:center;}
        h2 {color:#d32f2f; border-bottom:2px solid #d32f2f; padding-bottom:8px;}
        table {width:100%; border-collapse:collapse; margin:25px 0; background:white; box-shadow:0 4px 12px rgba(0,0,0,0.1);}
        th {background:#d32f2f; color:white; padding:12px; text-align:left;}
        td {padding:10px; border-bottom:1px solid #ddd;}
        tr:hover {background:#fff5f5;}
        .file {background:#ffebee; font-weight:bold; color:#b71c1c;}
        .error {color:#b71c1c;}
        .severity-error {background:#ffebee;}
        .count {text-align:center; font-size:2em; margin:30px 0; color:#d32f2f;}
        .summary {background:#fff3e0; padding:15px; border-radius:8px; margin:20px 0;}
        footer {margin-top:60px; text-align:center; color:#777; font-size:0.9em;}
    </style>
</head>
<body>
    <h1>Rapport Checkstyle — Audit Qualité et Sécurité</h1>
    <p class="count">
        <strong><xsl:value-of select="count(.//error)"/> violations détectées</strong>
    </p>
    <div class="summary">
        <strong>Projet analysé :</strong> client-app — <strong>Date :</strong> 05 décembre 2025<br/>
        <strong>Conclusion :</strong> Code fonctionnel mais qualité insuffisante pour un projet professionnel.
    </div>

    <table>
        <tr>
            <th>Fichier</th>
            <th>Ligne</th>
            <th>Sévérité</th>
            <th>Message</th>
        </tr>
        <xsl:for-each select="file">
            <xsl:variable name="fileName" select="@name"/>
            <xsl:for-each select="error">
                <tr class="severity-{@severity}">
                    <td>
                        <xsl:choose>
                            <xsl:when test="position()=1">
                                <span class="file">
                                    <xsl:value-of select="substring-after($fileName, 'client-sources/')"/>
                                </span>
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td><xsl:value-of select="@line"/></td>
                    <td class="error"><xsl:value-of select="@severity"/></td>
                    <td><xsl:value-of select="@message"/></td>
                </tr>
            </xsl:for-each>
        </xsl:for-each>
    </table>

    <h2>Résumé des problèmes majeurs</h2>
    <ul>
        <li><strong>Javadoc manquant</strong> : <xsl:value-of select="count(.//error[contains(@source,'MissingJavadoc')])"/> cas</li>
        <li><strong>Tabulations interdites</strong> : <xsl:value-of select="count(.//error[@source='com.puppycrawl.tools.checkstyle.checks.whitespace.FileTabCharacterCheck'])"/> fichiers</li>
        <li><strong>Lignes trop longues</strong> : <xsl:value-of select="count(.//error[@source='com.puppycrawl.tools.checkstyle.checks.sizes.LineLengthCheck'])"/></li>
        <li><strong>Nommage non conforme</strong> : <xsl:value-of select="count(.//error[contains(@source,'MemberNameCheck')])"/> (ex: safe_title)</li>
    </ul>

    <footer>
        Généré automatiquement via XSLT — Outil d’audit QOSC 2025<br/>
        <strong>Qualité de code : À corriger avant toute mise en production</strong>
    </footer>
</body>
</html>
</xsl:template>
</xsl:stylesheet>