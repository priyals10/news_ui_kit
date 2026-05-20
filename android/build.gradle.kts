import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            val android = project.extensions.getByName("android") as BaseExtension
            if (android.namespace == null) {
                // Ensure every project has a required namespace for AGP 8.x
                android.namespace = "dev.isar.${project.name.replace("-", ".").replace("_", ".")}"
                
                // CRITICAL FIX: Redirect isar_flutter_libs to our empty Shadow Manifest
                // This removes the "Duplicate package" conflict with AGP 8.1.1
                if (project.name.contains("isar_flutter_libs")) {
                    android.sourceSets.getByName("main").manifest.srcFile("${rootProject.projectDir}/app/src/main/shadow_manifest.xml")
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
