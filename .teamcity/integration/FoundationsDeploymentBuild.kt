package integration

import common.jelastic.createEnvironment
import common.templates.NexusDockerLogin
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.DslContext

class FoundationsDeploymentBuild(
    dockerTag: String,
) : BuildType({
    templates(
        NexusDockerLogin
    )

    name = "Deploy Foundations"

    vcs {
        root(DslContext.settingsRoot)
    }

    failureConditions {
        executionTimeoutMin = 30
    }

    val successTextPostgres = "success_text_postgres.txt"
    val successTextKubernetes = "success_text_kubernetes.txt"

    steps {
        createEnvironment(
            envName = "jelasticozor-db",
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/postgres/v2.0.0/manifest.yaml",
            envPropsQueries = listOf(
                Pair("DATABASE_HOSTNAME", "${'$'}{nodes.sqldb.master.url}"),
                Pair("DATABASE_ADMIN_USER", "webadmin"),
                Pair("DATABASE_ADMIN_PASSWORD", "${'$'}{nodes.sqldb.password}")
            ),
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./database",
            outputSuccessTextFile = "../$successTextPostgres",
        )
        // TODO: initialize database with hasura and fusionauth tables
        createEnvironment(
            envName = "jelasticozor-engine",
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/kubernetes/v1.25.4/manifest.jps",
            envPropsQueries = listOf(Pair("KUBERNETES_API_TOKEN", "${'$'}{globals.token}"), Pair("KUBERNETES_API_URL", "${'$'}{env.protocol}://${'$'}{env.domain}/api/")),
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./kubernetes",
            outputSuccessTextFile = successTextKubernetes
        )
        // TODO: reactivate when jelastic bug with addition of nginx node is fixed
        //createEnvironment(
        //    envName = "jelasticozor-engine",
        //    manifestUrl = "https://raw.githubusercontent.com/jelasticozor/deployment-infrastructure/master/ssl.yaml",
        //    jsonSettingsFile = "settings.json",
        //    dockerToolsTag = dockerTag,
        //    workingDir = "./nginx"
        //)
        // TODO: install helm charts
    }

    artifactRules = """
        $successTextPostgres, 
        $successTextKubernetes,
    """.trimIndent()
})