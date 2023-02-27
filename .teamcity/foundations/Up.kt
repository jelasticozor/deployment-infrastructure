package foundations

import common.jelastic.exposeKubernetesApiServer
import common.jelastic.getEnvironmentProperties
import common.jelastic.hideKubernetesApiServer
import common.templates.NexusDockerLogin
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.DslContext
import jetbrains.buildServer.configs.kotlin.buildSteps.script

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

    vcs {
        root(DslContext.settingsRoot)
    }

    failureConditions {
        executionTimeoutMin = 60
    }

    steps {
        getEnvironmentProperties(
            envName = databaseName,
            envPropsQueries = listOf(
                Pair("DATABASE_URL", "${'$'}{nodes.sqldb.master.url}"),
                Pair("DATABASE_PORT", "5432"),
            ),
            dockerToolsTag = dockerTag,
        )
        script {
            name = "Publish Database Hostname"
            scriptContent = """
                #! /bin/sh
                
                echo "##teamcity[setParameter name='env.DATABASE_HOSTNAME' value='${'$'}{DATABASE_URL#https://}']"
            """.trimIndent()
        }
        createFusionAuthDatabase(workingDir = databaseFolder)
        getEnvironmentProperties(
            envName = databaseName,
            envPropsQueries = listOf(
                Pair("FQDN", "${'$'}{env.domain}"),
            ),
            dockerToolsTag = dockerTag,
        )
        exposeKubernetesApiServer(
            envName = clusterName,
            envPropsQueries = listOf(
                Pair("KUBERNETES_API_URL", "https://${'$'}{env.domain}/api"),
            ),
            dockerToolsTag = dockerTag
        )
        installHelmCharts(
            workingDir = ".",
            dockerToolsTag = dockerTag,
        )
        hideKubernetesApiServer(
            envName = clusterName,
            dockerToolsTag = dockerTag,
        )
    }
})