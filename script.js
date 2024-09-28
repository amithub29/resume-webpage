fetch('https://khiwrftbrb.execute-api.us-east-1.amazonaws.com/')
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json(); // Parse response JSON
    })
    .then(data => {
        const element = document.getElementById('count');
        element.innerHTML = `${data.view_count}`;
    })
    .catch(error => {
        console.error('There was a problem with the fetch operation:', error);
    });
