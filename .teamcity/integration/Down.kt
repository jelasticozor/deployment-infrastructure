package integration

import common.jelastic.deleteEnvironment
import common.templates.NexusDockerLogin
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.DslContext

class Down(
    dockerTag: String,
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

    val databaseName = "jelasticozor-db-staging"
    val clusterName = "jelasticozor-engine-staging"

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