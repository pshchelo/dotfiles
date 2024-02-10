import apt


def get_installed_packages() -> list[apt.package.Package]:
    return [pkg for pkg in apt.Cache() if pkg.is_installed]


def is_local(package: apt.package.Package) -> bool:
    return not is_not_local(package)


def is_not_local(package: apt.package.Package):
    return bool(package.candidate.origins[0].origin)


def is_ubuntu(package: apt.package.Package) -> bool:
    return package.candidate.origins[0].origin.startswith("Ubuntu")


def is_not_ubuntu(package: apt.package.Package) -> bool:
    return not is_ubuntu(package)


# See https://apt-team.pages.debian.net/python-apt/library/apt.package.html#apt.package.Origin  # noqa
# for further details on the meanings of the below
def print_packages(packages: apt.package.Package) -> None:
    for package in packages:
        package_origin = package.candidate.origins[0]
        print(
            package.name,
            package_origin.origin,  # The Origin, as set in the Release file
            package_origin.archive,  # The archive (eg. Ubuntu release name)
            package_origin.component,  # The component (eg. main/universe)
            package_origin.site,  # The hostname of the site.
            # package_origin.label,  # The Label, as set in the Release file
            # Origin trusted (Release file signed by key in apt keyring)
            # package_origin.trusted,
        )


def main() -> None:
    packages = get_installed_packages()
    packages = filter(is_not_ubuntu, packages)
    packages = filter(is_not_local, packages)
    print_packages(packages)


if __name__ == "__main__":
    main()
