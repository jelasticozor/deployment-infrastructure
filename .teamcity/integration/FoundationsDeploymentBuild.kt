package integration

import common.templates.NexusDockerLogin
import jelastic.createEnvironment
import jelastic.publishPostgresEnvVars
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
        // TODO: this should publish the success text in the artifacts
        // TODO: this should create the success text file and parse it and publish the relevant data over teamcity
        createEnvironment(
            envName = "jelasticozor-db",
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/postgres/v2.0.0/manifest.yaml",
            jsonSettingsFile = "settings.json",
            dockerToolsTag = dockerTag,
            workingDir = "./database",
            outputSuccessTextFile = "../$successTextPostgres",
        )
        publishPostgresEnvVars(successTextPostgres, dockerTag)
        // TODO: initialize database with hasura and fusionauth tables
        // TODO: this should publish the success text in the artifacts
        createEnvironment(
            envName = "jelasticozor-engine",
            manifestUrl = "https://raw.githubusercontent.com/jelastic-jps/kubernetes/v1.25.4/manifest.jps",
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
})