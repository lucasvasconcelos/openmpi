OpenMPI codes

- Including a Dockerfile to build a Debian with OpenMPI and nopasswd ssh configured to run tests between two or more containers, simulating different machines. You can share volumes among the containers, use a NFS Server or just scp the same OpenMPI codes to each container.
- NOTE: The keys that can be found on build/ directory were created just for this container and they aren't used in nowhere else.
