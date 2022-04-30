vim.cmd("command! BCLaunch lua require('build_config.launch').launch()")

vim.cmd("command! BCConanInstall lua require('build_config.conan').install()")
vim.cmd("command! BCConanCreate lua require('build_config.conan').create()")

vim.cmd("command! BCCMakeConfigure lua require('build_config.cmake').configure()")
vim.cmd("command! BCCMakeBuild lua require('build_config.cmake').build()")
vim.cmd("command! BCCMakeInstall lua require('build_config.cmake').install()")
vim.cmd("command! BCCMakeClean lua require('build_config.cmake').clean()")
vim.cmd("command! BCCMakeLinkCompileCommands lua require('build_config.cmake').link_compile_commands()")

vim.cmd([[
    function! BuildRun()
        execute 'BCCMakeBuild'
        execute 'BCLaunch'
    endfunction

    command! BCCMakeBuildLaunch call BuildRun()
]])

vim.cmd("command! BCBuildDevcontainer lua require('build_config.devcontainer').build_container()")
vim.cmd("command! BCLaunchDevcontainer lua require('build_config.devcontainer').launch_container()")
vim.cmd("command! BCStopDevcontainer lua require('build_config.devcontainer').stop_container()")
