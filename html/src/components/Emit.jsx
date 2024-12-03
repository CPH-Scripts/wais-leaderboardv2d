const emit = (name, data, cb) => {
    fetch(`https://wais-leaderboardv2/${name}`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify(data),
    }).then(resp => resp.json()).then(data => {if (cb) {cb(data); }}).catch(error => {console.error('Fetch Error:', error);});
};

export default emit