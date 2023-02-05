package integration

import common.templates.NexusDockerLogin
import common.jelastic.deleteEnvironment
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.DslContext

class FoundationsDestructionBuild(
    dockerTag: String,
) : BuildType({
    templates(
        NexusDockerLogin
    )

    name = "Destroy Foundations"

    vcs {
        root(DslContext.settingsRoot)
    }

    failureConditions {
        executionTimeoutMin = 30
    }

    steps {
        deleteEnvironment(
            envName = "jelasticozor-engine",
            dockerToolsTag = dockerTag,
        )
        deleteEnvironment(
            envName = "jelasticozor-db",
            dockerToolsTag = dockerTag,
        )
    }
})