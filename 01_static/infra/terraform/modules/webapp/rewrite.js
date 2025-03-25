function handler(event) {
    const request = event.request;
    if (request.uri.endsWith('/')) {
        request.uri += 'index.html';
    } else if (!request.uri.includes('.')) {
        request.uri += '/index.html';
    }
    return request;
}