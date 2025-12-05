<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/BugCollection">
<html lang="fr">
<head>
    <meta charset="UTF-8"/>
    <title>Rapport SpotBugs - Audit QOSC (05/12/2025)</title>
    <style>
        body {font-family:Arial,sans-serif;margin:40px;background:#f9f9f9;color:#333;}
        h1 {color:#c62828;text-align:center;}
        table {width:100%;border-collapse:collapse;margin:25px 0;background:white;}
        th {background:#c62828;color:white;padding:12px;text-align:left;}
        td {padding:10px;border-bottom:1px solid #ddd;}
        tr:hover {background:#fff5f5;}
        .count {text-align:center;font-size:2em;margin:30px 0;color:#c62828;}
        footer {margin-top:60px;text-align:center;color:#777;font-size:0.9em;}
    </style>
</head>
<body>
    <h1>Rapport SpotBugs</h1>
    <p class="count"><strong><xsl:value-of select="@total_bugs"/> bugs détectés (Priorité 2: <xsl:value-of select="@priority_2"/>)</strong></p>

    <h2>Bugs Détailés</h2>
    <table>
        <tr><th>Type</th><th>Priorité</th><th>Catégorie</th><th>Message Court</th><th>Message Long</th><th>Classe/Méthode</th><th>Ligne</th></tr>
        <xsl:for-each select="BugInstance">
            <tr>
                <td><xsl:value-of select="@type"/></td>
                <td><xsl:value-of select="@priority"/></td>
                <td><xsl:value-of select="@category"/></td>
                <td><xsl:value-of select="ShortMessage"/></td>
                <td><xsl:value-of select="LongMessage"/></td>
                <td><xsl:value-of select="Class/@classname"/>.<xsl:value-of select="Method/@name"/></td>
                <td><xsl:value-of select="SourceLine/@start"/></td>
            </tr>
        </xsl:for-each>
    </table>

    <h2>Résumé Projet</h2>
    <ul>
        <li>Total bugs : <xsl:value-of select="FindBugsSummary/@total_bugs"/></li>
        <li>Total classes : <xsl:value-of select="FindBugsSummary/@total_classes"/></li>
        <li>Total size : <xsl:value-of select="FindBugsSummary/@total_size"/></li>
    </ul>

    <footer>Généré le 05/12/2025 — Analyse SpotBugs 4.8.3.0</footer>
</body>
</html>
</xsl:template>
</xsl:stylesheet>