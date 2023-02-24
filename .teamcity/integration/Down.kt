package integration

import common.templates.NexusDockerLogin
import common.jelastic.deleteEnvironment
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

    // TODO: the environment names should be obtained from a state file
    steps {
        deleteEnvironment(
            envName = "jelasticozor-engine-staging",
            dockerToolsTag = dockerTag,
        )
        deleteEnvironment(
            envName = "jelasticozor-db-staging",
            dockerToolsTag = dockerTag,
        )
    }
})