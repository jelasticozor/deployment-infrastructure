package infrastructure

import common.jelastic.createEnvironment
import common.templates.NexusDockerLogin
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.DslContext

class Up(
    dockerTag: String,
    databaseFolder: String,
    databaseName: String,
    clusterName: String,
) : BuildType({
    templates(
        NexusDockerLogin
    )

    name = "Up"
    id("InfraUp")

    vcs {
        root(DslContext.settingsRoot)
    }

    failureConditions {
        executionTimeoutMin = 60
    }

    steps {
        createEnvironment(
            envName = databaseName,
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/postgres/v2.0.0/manifest.yaml",
            envPropsQueries = listOf(
                Pair("DATABASE_URL", "${'$'}{nodes.sqldb.master.url}"),
                Pair("DATABASE_PORT", "5432"),
                // TODO: the following 2 properties need to be stored in the vault
                Pair("DATABASE_ADMIN_USER", "webadmin"),
                Pair("DATABASE_ADMIN_PASSWORD", "${'$'}{nodes.sqldb.password}")
            ),
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = databaseFolder,
            region = "new",
        )
        createEnvironment(
            envName = clusterName,
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/kubernetes/v1.25.4/manifest.jps",
            envPropsQueries = listOf(
                // TODO: the following property needs to be stored in the vault
                Pair("KUBERNETES_API_TOKEN", "${'$'}{globals.token}"),
                Pair("FQDN", "${'$'}{env.domain}"),
            ),
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./kubernetes",
            region = "new",
        )
        createEnvironment(
            envName = clusterName,
            manifestUrl = "https://raw.githubusercontent.com/jelasticozor/deployment-infrastructure/main/ssl.yaml",
            dockerToolsTag = dockerTag,
        )
    }
})