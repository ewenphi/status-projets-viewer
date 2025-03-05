project(
    'auto-updater',
    'c',
    version: '0.1.2.2.1',
    default_options: ['warning_level=3', 'optimization=3'],
)

libcurl = dependency('libcurl')

executable('auto-updater', 'src/main.c', dependencies: [libcurl], install: true)