import common.templates.NexusDockerLogin
import integration.FoundationsDeploymentBuild
import integration.FoundationsDestructionBuild
import jetbrains.buildServer.configs.kotlin.*

/*
The settings script is an entry point for defining a TeamCity
project hierarchy. The script should contain a single call to the
project() function with a Project instance or an init function as
an argument.

VcsRoots, BuildTypes, Templates, and subprojects can be
registered inside the project using the vcsRoot(), buildType(),
template(), and subProject() methods respectively.

To debug settings scripts in command-line, run the

    mvnDebug org.jetbrains.teamcity:teamcity-configs-maven-plugin:generate

command and attach your debugger to the port 8000.

To debug in IntelliJ Idea, open the 'Maven Projects' tool window (View
-> Tool Windows -> Maven Projects), find the generate task node
(Plugins -> teamcity-configs -> teamcity-configs:generate), the
'Debug' option is available in the context menu for the task.
*/

version = "2022.10"

project {
    params {
        param("teamcity.ui.settings.readOnly", "true")
    }

    template(NexusDockerLogin)

    val dockerTag = "e24febf1"

    subProject {
        id("Development")
        name = "Development"

        val foundationsDeploymentBuild = FoundationsDeploymentBuild(
            dockerTag = dockerTag
        )
        buildType(foundationsDeploymentBuild)
        val foundationsDestructionBuild = FoundationsDestructionBuild(
            dockerTag = dockerTag
        )
        buildType(foundationsDestructionBuild)
    }

    subProject {
        id("Production")
        name = "Production"
    }
}