package foundations

import common.templates.NexusDockerLogin
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.DslContext

class Down(
    dockerTag: String,
    databaseName: String,
    clusterName: String,
) : BuildType({
    templates(
        NexusDockerLogin
    )

    name = "Down"

    vcs {
        root(DslContext.settingsRoot)
    }

    failureConditions {
        executionTimeoutMin = 30
    }

    steps {
        // TODO: uninstall databases / helm charts
    }
})