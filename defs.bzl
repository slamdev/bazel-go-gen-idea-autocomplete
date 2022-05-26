load("@io_bazel_rules_go//go:def.bzl", "go_context")

def _impl(ctx):
    go = go_context(ctx)

    out = ctx.actions.declare_file(ctx.label.name + ".go")
    # out = go.declare_file(go, name = ctx.label.name, ext = ".go")

    ctx.actions.write(
        output = out,
        content = ctx.attr.content,
    )

    library = go.new_library(go, srcs = [out], importpath = ctx.attr.importpath)
    source_attrs = {
        "_go_context_data": ctx.attr._go_context_data,
    }
    source = go.library_to_source(go, source_attrs, library, ctx.coverage_instrumented())
    archive = go.archive(go, source)
    return [
        library,
        source,
        archive,
        DefaultInfo(
            files = depset([archive.data.file]),
        ),
        OutputGroupInfo(
            cgo_exports = archive.cgo_exports,
            compilation_outputs = [archive.data.file],
            go_generated_srcs = depset([out]),
        ),
    ]

go_gen = rule(
    implementation = _impl,
    toolchains = ["@io_bazel_rules_go//go:toolchain"],
    attrs = {
        "content": attr.string(),
        "importpath": attr.string(),
        "_go_context_data": attr.label(
            default = "@io_bazel_rules_go//:go_context_data",
        ),
    },
)
