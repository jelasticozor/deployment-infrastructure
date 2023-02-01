package integration

import common.templates.NexusDockerLogin
import jelastic.createEnvironment
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.DslContext

class FoundationsDeploymentBuild(
    dockerTag: String
) : BuildType({
    templates(
        NexusDockerLogin
    )

    name = "Foundations"

    vcs {
        root(DslContext.settingsRoot)
    }

    steps {
        createEnvironment(
            envName = "jelasticozor-db",
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/postgres/v2.0.0/manifest.yaml",
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./database"
        )
        createEnvironment(
            envName = "jelasticozor-engine",
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/kubernetes/v1.25.4/manifest.jps",
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./kubernetes"
        )
    }
})