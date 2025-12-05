
# Prerequisite

sudo apt update

sudo apt install xsltproc

# Building
 
 mvn site -Dcheckstyle.skip=true -Dpmd.skip=false -Dspotbugs.skip=false

# Styling

xsltproc checkstyle.xsl target/checkstyle-result.xml  > target/audit-checkstyle-result.html

# 
