load("@io_bazel_rules_go//go:def.bzl", "go_binary", "go_library")
load(":defs.bzl", "go_gen")

go_library(
    name = "lib",
    srcs = [
        "main.go",
    ],
    importpath = "main",
    deps = [
        ":rulew",
    ],
)

go_binary(
    name = "bin",
    embed = [":lib"],
)

go_gen(
    name = "rulew",
    content = """package rulew

func PrintRule() {
    println("rule")
}""",
    importpath = "rulew",
)
