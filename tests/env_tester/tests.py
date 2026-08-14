import logging
import pathlib
import shutil
import subprocess

import pytest
import yaml

CHAMPIONS = pathlib.Path("./champions")
CONFIG = pathlib.Path("./config.yml")
CONFIG_PLAYER = pathlib.Path("../../games/tictactoe/tictactoe.yml")
EXPECTED_DUMP = pathlib.Path("./expected_dump.txt")

def assert_process(commands, msg = None, msg_timeout = None):
    try:
        process = subprocess.run(commands, capture_output=True, timeout=10)
        stdout = "no stdout"
        if process.stdout != None:
            stdout = process.stdout.decode("utf-8")

        stderr = "no stderr"
        if process.stderr != None:
            stderr = process.stderr.decode("utf-8")

        if msg == None:
            msg = f"Command Failed: {commands}"

        assert (
            process.returncode == 0
        ), f"""{msg}
stderr:
${stdout}

stdout:
{stderr}"
            """

    except subprocess.TimeoutExpired as e:
        stdout = "no stdout"
        if e.stdout != None:
            stdout = e.stdout.decode("utf-8")

        stderr = "no stderr"
        if e.stderr != None:
            stderr = e.stderr.decode("utf-8")

        if msg_timeout == None:
            msg_timeout = f"Timeout: {commands}:"

        assert (
            False
        ), f"""{msg_timeout}
stderr:
${stderr}

stdout:
{stdout}
            """

@pytest.fixture(scope="session")
def stechec2_generator_path(tmp_path_factory):
    player_env = (tmp_path_factory.mktemp("player_env")).resolve()
    assert_process(["stechec2-generator", "player", str(CONFIG_PLAYER.resolve()), str(player_env)])
    return player_env


@pytest.mark.parametrize(
    ("champion_path", "language"), [
        (pathlib.Path("./champions/Champion.hs"), "haskell"),
        (pathlib.Path("./champions/Champion.java"), "java"),
        (pathlib.Path("./champions/Champion.py"), "python"),
        (pathlib.Path("./champions/champion.c"), "c"),
        (pathlib.Path("./champions/champion.cc"), "cxx"),
        # TODO: C# (Mono) runtime is broken (mono_thread_detach SIGABRT crash in libmonosgen-2.0.so).
        # (pathlib.Path("./champions/champion.cs"), "cs"),
        # TODO: JS (SpiderMonkey) bindings are broken (define_enum_error undeclared in generated interface.cc).
        # (pathlib.Path("./champions/champion.js"), "js"),
        (pathlib.Path("./champions/champion.ml"), "caml"),
        (pathlib.Path("./champions/champion.php"), "php"),
        (pathlib.Path("./champions/champion.rs"), "rust"),
    ]
)
class TestChampionGroup:
    def test_compile(self, champion_path: pathlib.Path, language: str, stechec2_generator_path: pathlib.Path) -> None:
        folder_champion = stechec2_generator_path / language
        assert(folder_champion.exists())
        shutil.copy2(champion_path, folder_champion);
        assert_process(["make", "--directory", str(folder_champion.absolute())], f"Compile Failed for {language} champion")

    def test_run_stechec2(
        self, champion_path: pathlib.Path, language: str, stechec2_generator_path: pathlib.Path
    ) -> None:
        folder_champion = stechec2_generator_path / language
        champion_library = (folder_champion / "champion.so").resolve()
        assert (
            champion_library.exists()
        ), f"Dynamic Library doesn't exist for {champion_path.name} champion!"

        with CONFIG.open() as config_file:
            config = yaml.safe_load(config_file)
            config["clients"] = [
                str(champion_library.resolve()),
                str(champion_library.resolve()),
            ]

            dump_path = (stechec2_generator_path / "dump.txt").resolve()
            config["dump"] = str(dump_path)

            for resolve_config in ("rules", "server", "client"):
                config_path = pathlib.Path(config[resolve_config]).resolve()
                assert (
                    config_path.exists()
                ), f"{config_file} doesn't exists. Check the configuration"
                config[resolve_config] = str(config_path)

            new_config_path = stechec2_generator_path / "config.yml"
            with new_config_path.open("w") as new_config_file:
                yaml.safe_dump(config, new_config_file)

        assert_process(["stechec2-run", str(new_config_path)], f"Run failed for multi-thread {language} champion", f"Timeout for multi-thread {language} champion")
        assert_process(["diff", str(EXPECTED_DUMP), str(dump_path)], f"Diff failed for multi-thread {language} champion")

        assert_process(["stechec2-run", "--time", "0",  str(new_config_path)], f"Run failed for single-thread {language} champion", f"Timeout for single-thread {language} champion")
        assert_process(["diff", str(EXPECTED_DUMP), str(dump_path)], f"Diff failed for single-thread {language} champion")
