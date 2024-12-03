import { useState, useMemo, useEffect, useContext, useRef } from "react";
import { Context } from "./Context";
import OtherProfile from "./OtherProfile";

const Board = () => {
    const { Lang, boardData, setOtherProfile } = useContext(Context);
    const [visibleData, setVisibleData] = useState(Object.keys(boardData).sort((a, b) => boardData[b].kills - boardData[a].kills).slice(0, 10)); 
    const loaderRef = useRef(null);

    const handleIndexToNumber = (index) => index + 1;
    const trophy = (color, opacity, key) => {
        return (
            <svg xmlns="http://www.w3.org/2000/svg" width="49" height="41" fill="none" viewBox="0 0 49 41" key={key}>
                <path fill={`url(#a-${key})`} fillOpacity={opacity} fillRule="evenodd" d="M9.73.066c-.035.036-.064.59-.064 1.232v1.166H0v1.408C0 8.13 1.229 12.686 3.194 15.72c1.187 1.832 2.887 3.423 4.606 4.31 1.793.926 3.276 1.272 5.646 1.317l1.723.032.523.67c.695.89 2.012 2.237 2.767 2.83.694.547 1.948 1.308 2.62 1.59l.453.19v3.623l.001 3.622h-7.082v4.534h-2.297V41h24.692v-2.563h-2.297v-4.533h-7.082v-3.647c0-2.573.03-3.646.104-3.646.177 0 1.631-.785 2.3-1.241.994-.68 2.182-1.803 3.108-2.94l.852-1.047 1.723-.034c2.371-.047 3.856-.394 5.646-1.318 1.952-1.008 3.74-2.79 5.01-4.995C47.95 12.019 49 7.812 49 3.872V2.464h-9.666V1.388c0-.592-.026-1.146-.058-1.232C39.223.015 37.833 0 24.506 0 16.414 0 9.765.03 9.73.066Zm.168 5.97c.024.123.092.666.151 1.208.374 3.456 1.242 6.733 2.482 9.378l.67 1.427-.547-.065c-2.365-.282-4.038-1.062-5.494-2.56-1.804-1.854-3.117-4.9-3.66-8.487a34.265 34.265 0 0 1-.15-1.06c0-.034 1.463-.062 3.252-.062h3.252l.044.222Zm35.752-.159c0 .288-.35 2.252-.541 3.042-1.085 4.467-3.315 7.448-6.388 8.539-.757.269-2.706.642-2.808.538-.026-.027.244-.682.6-1.456 1.225-2.67 2.069-5.889 2.438-9.296a25.56 25.56 0 0 1 .151-1.207l.044-.222h3.252c1.789 0 3.252.028 3.252.062Z" clipRule="evenodd"/>
                <defs>
                    <radialGradient id={`a-${key}`} cx="0" cy="0" r="1" gradientTransform="matrix(18.58621 28.18747 -33.91444 22.36245 24.5 20.5)" gradientUnits="userSpaceOnUse">
                        <stop stopColor={color}/>
                        <stop offset="1" stopColor={color} stopOpacity=".25"/>
                    </radialGradient>
                </defs>
            </svg>
        )
    }
 
    const sortedBoardData = useMemo(() => {
        return Object.keys(boardData).sort((a, b) => boardData[b].kills - boardData[a].kills);
    }, [boardData]);

    const loadMoreData = () => {
        const currentLength = visibleData.length;
        const moreData = sortedBoardData.slice(currentLength, currentLength + 10);
        setVisibleData(prev => [...prev, ...moreData]);
    };
    
    useEffect(() => {
        const observer = new IntersectionObserver((entries) => {
            if (entries[0].isIntersecting) {
                loadMoreData(boardData);
            }
        }, { threshold: 1 });

        if (loaderRef.current) {
            observer.observe(loaderRef.current);
        }

        return () => {
            if (loaderRef.current) {
                observer.unobserve(loaderRef.current);
            }
        };
    }, [visibleData]);

    useEffect(() => {
        const newVisibleData = {...visibleData}
        const currentLength = newVisibleData.length;
        setVisibleData(sortedBoardData.slice(0, currentLength));
    }, [boardData]);

    const buildBoard = useMemo(() => {
        return visibleData.map((key, index) => {
            const userData = boardData[key];
            const newIndex = handleIndexToNumber(index);
            return (
                <div className="line"
                    key={`${key}-${index}`}
                    onClick={() => {
                        setOtherProfile({
                            show: true,
                            name: userData.name,
                            profile: {
                                banner: userData.profile.banner,
                                avatar: userData.profile.avatar,
                                status: userData.profile.status,
                                country: userData.profile.country,
                            },
                    
                            kills: userData.kills,
                            deaths: userData.deaths,
                        })
                    }}
                >
                    <div className={`line-rank rank${newIndex}`}>
                        {trophy((newIndex === 1 ? "#FFEC43" : newIndex === 2 ? "#FFFFFF" : newIndex === 3 ? "#FF8743" : "#FFFFFF"), '.1', `${key}-${index}`)}
                        <span style={{ mixBlendMode: (newIndex <= 3) ? 'hard-light' : 'soft-light' }}>#{newIndex}</span>
                        {newIndex <= 3 && <div className={`line-shadow rank${newIndex}`}></div>}
                    </div>
                    <div className="line-name">
                        <span>{userData.name}</span>
                    </div>
                    <div className="line-kills">
                        <span>{userData.kills}</span>
                        <div className="line-image">
                            <img src="../../public/images/shuriken2.png" id="stat-icon" />
                        </div>
                        <div className="line-shadow"></div>
                    </div>
                    <div className="line-deaths">
                        <span>{userData.deaths}</span>
                        <div className="line-image">
                            <img src="../../public/images/skull2.png" id="stat-icon" />
                        </div>
                        <div className="line-shadow"></div>
                    </div>
                </div>
            )
        });
    }, [visibleData]);

    return (
        <div className="leaderboard">
            <div className="leaderboard-titles">

                <div className="leaderboard-title rank">
                    <span>{Lang.rank}</span>
                </div>
                
                <div className="leaderboard-title name">
                    <span>{Lang.name}</span>
                </div>

                <div className="leaderboard-title statics">
                    <span>{Lang.kills}</span>
                </div>

                <div className="leaderboard-title statics">
                    <span>{Lang.deaths}</span>
                </div>

            </div>
            <div className="leaderboard-wrapper">
                {buildBoard}
                <div className="progress-fill"
                    style={{
                        display: visibleData.length === Object.keys(boardData).length ? 'none' : 'flex'
                    }}
                >
                    <div ref={loaderRef} className="progressbar" style={{}}></div>
                </div>
            </div>
        </div>
    )
}

export default Board;