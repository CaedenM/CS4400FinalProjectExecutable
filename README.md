## Folder Structure

The workspace contains two folders:

- `src`: the folder to maintain sources
- `lib`: the folder to maintain dependencies

## Setup

Execute "java --enable-preview -jar .\Phase4.jar" from the command line. DO NOT ATTEMPT to run by double-clicking. This will not work.

Once the Java program has launched, list your database username, password, port and database name as prompted (colon-separated).
If this fails, carefully check your username, password, port and database name. 

Once these inputs are correct, you will automatically face the login screen of the phase-four portal.

If fresh compilation is required:
Recomended: IDE such as Elipse, InteliJ, or VSCode
* Create a new Java project <project name>.
* Copy the contents of Phase4.src into <project name>.src
* Create executable JAR with Main.java as the program's entry point.

## Technologies Used
* Java - a general-purpose, cross-platform programming language
 * Installation of the latest Java version may be required.
* javax.swing.* - java package for UI
* mysql-connector-java-8.0.24.jar - A Java library for establishing connections with SQL servers
* JDBC Driver - a driver for making connections with a sql servers. Used by mysql-connector-java-8.0.24.jar

## Work Distribution
* UI Design - Caeden
* SQL Implementations:
  * Windows 2, 4, 16 - Madeline
  * Windows 5, 6, 7, 8, 10, 11, 12, 14 - Aaron
  * Windows 17, 18, 19 - Alexa
  * Windows 1, 3, 9, 13, 15 - Caeden
