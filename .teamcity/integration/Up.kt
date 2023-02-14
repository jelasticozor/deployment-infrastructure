package integration

import common.jelastic.createEnvironment
import common.templates.NexusDockerLogin
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.DslContext
import jetbrains.buildServer.configs.kotlin.buildSteps.script

class Up(
    dockerTag: String,
) : BuildType({
    templates(
        NexusDockerLogin
    )

    name = "Up"

    vcs {
        root(DslContext.settingsRoot)
    }

    failureConditions {
        executionTimeoutMin = 60
    }

    val databaseFolder = "./database"

    val dbName = "jelasticozor-db-staging"
    val clusterName = "jelasticozor-engine-staging"

    steps {
        // TODO: we publish sensitive data as environment variables (e.g. passwords, api keys); we should fix that
        // --> maybe define a dedicated vault for the jelasticozor engine in a separate environment?
        createEnvironment(
            envName = dbName,
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/postgres/v2.0.0/manifest.yaml",
            envPropsQueries = listOf(
                Pair("DATABASE_URL", "${'$'}{nodes.sqldb.master.url}"),
                Pair("DATABASE_PORT", "5432"),
                Pair("DATABASE_ADMIN_USER", "webadmin"),
                Pair("DATABASE_ADMIN_PASSWORD", "${'$'}{nodes.sqldb.password}")
            ),
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = databaseFolder,
            region = "new",
        )
        script {
            name = "Publish Database Hostname"
            scriptContent = """
                #! /bin/sh
                
                echo "##teamcity[setParameter name='env.DATABASE_HOSTNAME' value='${'$'}{DATABASE_URL#https://}']"
            """.trimIndent()
        }
        createFusionAuthDatabase(workingDir = databaseFolder)
        createEnvironment(
            envName = clusterName,
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/kubernetes/v1.25.4/manifest.jps",
            envPropsQueries = listOf(
                Pair("KUBERNETES_API_TOKEN", "${'$'}{globals.token}"),
                // TODO: this will not work, the following api url must be https, but kubectl won't be happy because the certificate is not trusted
                // TODO: the most secure option to install the helm charts is to install them as part of the kubernetes manifest installation
                Pair("KUBERNETES_API_URL", "http://${'$'}{nodes.k8sm.master.intIP}:6443"),
                Pair("FQDN", "${'$'}{env.domain}"),
                Pair("USER_EMAIL_ADDRESS", "${'$'}user.email")
            ),
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./kubernetes",
            region = "new",
        )
        script {
            name = "Wait For Kubernetes API"
            scriptContent = """
                #! /bin/sh
                
                for i in ${'$'}(seq 1 120) ; do
                    status_code=${'$'}(curl -s -o /dev/null -w "%{http_code}" ${'$'}KUBERNETES_API_URL/version)
                    if [ "${'$'}status_code" = "200" ] ; then
                        break
                    fi
                    sleep 1
                done
            """.trimIndent()
        }
        installHelmCharts(
            workingDir = ".",
            dockerToolsTag = dockerTag,
        )
        createEnvironment(
            envName = clusterName,
            manifestUrl = "https://raw.githubusercontent.com/jelasticozor/deployment-infrastructure/main/ssl.yaml",
            dockerToolsTag = dockerTag,
        )
    }
})