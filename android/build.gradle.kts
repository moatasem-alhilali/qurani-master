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
    // Flutter plugin modules still default to Java/Kotlin 1.8, which cannot inline
    // bytecode from AndroidX artifacts built for JVM 11 (e.g. home_widget -> glance).
    val forceJava11 = {
        extensions.findByName("android")?.let { ext ->
            (ext as com.android.build.gradle.BaseExtension).compileOptions.apply {
                sourceCompatibility = JavaVersion.VERSION_11
                targetCompatibility = JavaVersion.VERSION_11
            }
        }
        Unit
    }
    if (state.executed) forceJava11() else afterEvaluate { forceJava11() }

    project.evaluationDependsOn(":app")
}

// Applied once every module has been evaluated, so it overrides the `jvmTarget = "1.8"`
// that plugins set in their own build scripts.
gradle.projectsEvaluated {
    subprojects {
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
