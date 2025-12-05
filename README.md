# README — Audit QOSC (05/12/2025)

**Audité** : client-app (Spring Boot 3 + Lombok)  
**Outil** : qosc-generator (Maven)

## Stack

| Outil      | Version | Rôle                  | Violations |
|------------|---------|-----------------------|------------|
| Checkstyle | 9.3     | Style + Javadoc       | 108        |
| PMD        | 7.17.0  | Design/complexité     | 100+       |
| SpotBugs   | 4.8.3.0 | Bugs/sécurité         | Plusieurs  |
| Javadoc    | 3.6.3   | Doc obligatoire       | 50+        |

## Commandes

```bash
mvn clean verify  # Audit (échoue sur violations)
mvn site -Dcheckstyle.skip=true  # Rapport (target/site/index.html)
```

## Résultat

Code fonctionnel mais qualité insuffisante (doc 0%, complexité haute). Corriger avant prod.

## POM Complet

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.audit.qosc</groupId>
    <artifactId>qosc-generator</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
     
        <checkstyle.version>3.3.1</checkstyle.version>
        <pmd.version>3.28.0</pmd.version>
        <spotbugs.version>4.8.3.0</spotbugs.version>
        <javadoc.version>3.6.3</javadoc.version>
        <dependency.version>3.6.0</dependency.version>
        <compiler.version>3.11.0</compiler.version>
        <lombok.version>1.18.30</lombok.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>com.client</groupId>
            <artifactId>client-app</artifactId>
            <version>1.0</version>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>${lombok.version}</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>2.0.9</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <artifactId>maven-clean-plugin</artifactId>
                <version>3.2.0</version>
                <configuration>
                    <filesets>
                        <fileset>
                            <directory>target/client-sources</directory>
                            <includes><include>**/*</include></includes>
                            <excludes><exclude>.gitkeep</exclude></excludes>
                        </fileset>
                        <fileset>
                            <directory>target/client-classes</directory>
                            <includes><include>**/*</include></includes>
                            <excludes><exclude>.gitkeep</exclude></excludes>
                        </fileset>
                        <fileset>
                            <directory>target/audit</directory>
                            <includes><include>**/*</include></includes>
                            <excludes><exclude>.gitkeep</exclude></excludes>
                        </fileset>
                    </filesets>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-dependency-plugin</artifactId>
                <version>${dependency.version}</version>
                <executions>
                    <execution>
                        <id>unpack-client</id>
                        <phase>initialize</phase>
                        <goals><goal>unpack</goal></goals>
                        <configuration>
                            <artifactItems>
                                <artifactItem>
                                    <groupId>com.client</groupId>
                                    <artifactId>client-app</artifactId>
                                    <version>1.0</version>
                                    <type>jar</type>
                                    <classifier>sources</classifier>
                                    <outputDirectory>${project.build.directory}/client-sources</outputDirectory>
                                </artifactItem>
                            </artifactItems>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>${compiler.version}</version>
                <executions>
                    <execution>
                        <id>compile-client-sources</id>
                        <phase>compile</phase>
                        <goals><goal>compile</goal></goals>
                        <configuration>
                            <source>${maven.compiler.source}</source>
                            <target>${maven.compiler.target}</target>
                            <compilerArgs><arg>-parameters</arg></compilerArgs>
                            <annotationProcessorPaths>
                                <path>
                                    <groupId>org.projectlombok</groupId>
                                    <artifactId>lombok</artifactId>
                                    <version>${lombok.version}</version>
                                </path>
                            </annotationProcessorPaths>
                            <compileSourceRoots>
                                <compileSourceRoot>${project.build.directory}/client-sources</compileSourceRoot>
                            </compileSourceRoots>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-resources-plugin</artifactId>
                <version>3.3.1</version>
                <executions>
                    <execution>
                        <id>copy-pmd-rules</id>
                        <phase>validate</phase>
                        <goals><goal>copy-resources</goal></goals>
                        <configuration>
                            <outputDirectory>${project.build.outputDirectory}</outputDirectory>
                            <resources>
                                <resource>
                                    <directory>${basedir}</directory>
                                    <includes><include>pmd-rules.xml</include></includes>
                                </resource>
                            </resources>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-checkstyle-plugin</artifactId>
                <version>${checkstyle.version}</version>
                <configuration>
                    <configLocation>checkstyle.xml</configLocation>
                    <sourceDirectories>
                        <sourceDirectory>${project.build.directory}/client-sources</sourceDirectory>
                    </sourceDirectories>
                    <consoleOutput>true</consoleOutput>
                    <failsOnError>true</failsOnError>
                    <failOnViolation>true</failOnViolation>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-pmd-plugin</artifactId>
                <version>${pmd.version}</version>
                <configuration>
                    <targetDirectory>${project.build.directory}/audit/pmd</targetDirectory>
                    <includeSourcesFrom>
                        <includeSourceDirectory>${project.build.directory}/client-sources</includeSourceDirectory>
                    </includeSourcesFrom>
                </configuration>
                <executions>
                    <execution>
                        <id>pmd-generate</id>
                        <phase>validate</phase>
                        <goals><goal>pmd</goal></goals>
                        <configuration>
                            <rulesets><ruleset>${basedir}/pmd-rules.xml</ruleset></rulesets>
                            <format>xml</format>
                            <failOnViolation>false</failOnViolation>
                        </configuration>
                    </execution>
                    <execution>
                        <id>pmd-check</id>
                        <phase>validate</phase>
                        <goals><goal>check</goal></goals>
                        <configuration>
                            <failOnViolation>true</failOnViolation>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>com.github.spotbugs</groupId>
                <artifactId>spotbugs-maven-plugin</artifactId>
                <version>${spotbugs.version}</version>
                <configuration>
                    <classFilesDirectory>${project.build.directory}/client-classes</classFilesDirectory>
                    <effort>Max</effort>
                    <threshold>Low</threshold>
                    <includeFilterFile>spotbugs-security-include.xml</includeFilterFile>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-javadoc-plugin</artifactId>
                <version>${javadoc.version}</version>
                <configuration>
                    <sourcepath>${project.build.directory}/client-sources</sourcepath>
                    <doclint>all</doclint>
                </configuration>
            </plugin>
        </plugins>
    </build>

    <reporting>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-checkstyle-plugin</artifactId>
                <version>${checkstyle.version}</version>
                <configuration>
                    <configLocation>checkstyle.xml</configLocation>
                    <sourceDirectories>
                        <sourceDirectory>${project.build.directory}/client-sources</sourceDirectory>
                    </sourceDirectories>
                    <checkstyleResultsLocation>${project.build.directory}/checkstyle-result.xml</checkstyleResultsLocation>
                </configuration>
                <reportSets>
                    <reportSet>
                        <reports><report>checkstyle</report></reports>
                    </reportSet>
                </reportSets>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-pmd-plugin</artifactId>
                <version>${pmd.version}</version>
                <configuration>
                    <includeSourcesFrom>
                        <includeSourceDirectory>${project.build.directory}/client-sources</includeSourceDirectory>
                    </includeSourcesFrom>
                    <rulesets><ruleset>${basedir}/pmd-rules.xml</ruleset></rulesets>
                </configuration>
                <reportSets>
                    <reportSet>
                        <reports><report>pmd</report><report>cpd</report></reports>
                    </reportSet>
                </reportSets>
            </plugin>
            <plugin>
                <groupId>com.github.spotbugs</groupId>
                <artifactId>spotbugs-maven-plugin</artifactId>
                <version>${spotbugs.version}</version>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-javadoc-plugin</artifactId>
                <version>${javadoc.version}</version>
            </plugin>
        </plugins>
    </reporting>
</project>
```

## XSLTproc Usage

### Installation

- **Linux** (Debian/Ubuntu) : `sudo apt install xsltproc`
- **Linux** (Fedora) : `sudo dnf install libxslt`
- **macOS** : `brew install libxslt`
- **Windows** : Télécharge `libxslt` depuis [libxml2](http://www.xmlsoft.org/downloads.html) ; ajoute au PATH

### Génération HTML

```bash
xsltproc checkstyle-html.xsl checkstyle-result.xml > checkstyle-result.html
```

**Résultat** : Qualité insuffisante. Corriger.
