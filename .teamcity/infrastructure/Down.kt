package infrastructure

import common.jelastic.deleteEnvironment
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
    id("InfraDown")

    vcs {
        root(DslContext.settingsRoot)
    }

    failureConditions {
        executionTimeoutMin = 30
    }

    steps {
        deleteEnvironment(
            envName = clusterName,
            dockerToolsTag = dockerTag,
        )
        deleteEnvironment(
            envName = databaseName,
            dockerToolsTag = dockerTag,
        )
    }
})