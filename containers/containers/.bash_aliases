pingu() {
    where=$(pwd)
    docker run --rm -it --name pingu-container --volume $where:/workspace pingu:latest bash
}
