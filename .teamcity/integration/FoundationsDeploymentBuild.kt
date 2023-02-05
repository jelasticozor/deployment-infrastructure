package integration

import common.templates.NexusDockerLogin
import common.jelastic.createEnvironment
import common.jelastic.publishEnvVarsFromSuccessText
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
            successTextQuery = """
                PostgresHostname: ${'$'}{nodes.sqldb.master.url}  \nPostgresAdminUser: webadmin  \nPostgresAdminPassword: ${'$'}{nodes.sqldb.password}\n
            """.trimIndent(),
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./database",
            outputSuccessTextFile = "../$successTextPostgres",
        )
        publishEnvVarsFromSuccessText(successTextPostgres, dockerTag)
        // TODO: initialize database with hasura and fusionauth tables
        createEnvironment(
            envName = "jelasticozor-engine",
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/kubernetes/v1.25.4/manifest.jps",
            successTextQuery = """
                KubernetesApiToken: ${'$'}{globals.token}  \nRemoteApiEndpoint: ${'$'}{env.protocol}://${'$'}{env.domain}/api/\n
            """.trimIndent(),
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./kubernetes",
            outputSuccessTextFile = successTextKubernetes
        )
        publishEnvVarsFromSuccessText(successTextKubernetes, dockerTag)
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