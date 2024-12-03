import { useState, useContext, useEffect, useMemo } from "react"
import { Context } from "./Context"

const OtherProfile = () => {
    const { Lang, Ranks, otherProfile, closeOtherProfile } = useContext(Context)
    const [dataLoaded, setDataLoaded] = useState(false)

    const modalKDA = useMemo(() => {
        return isNaN(otherProfile.kills / otherProfile.deaths) ? 0.0 : (otherProfile.kills / otherProfile.deaths).toFixed(1);
    }, [otherProfile.kills, otherProfile.deaths]);

    const getRank = useMemo(() => {
        let latestRank = null;
        for (const key in Ranks) {
            const kda = modalKDA;
    
            if (kda >= Ranks[key].kda) {
                latestRank = key;
            }
        }

        return { 
            rank: latestRank,
            color: Ranks[latestRank].color,
        };
    }, [otherProfile.kills, otherProfile.deaths]);

    useEffect(() => {
        if (otherProfile.show) {
            setTimeout(() => {
                setDataLoaded(true)
            }, 1000)
        }
    }, [otherProfile])

    return (
        <div className="pop-up"
            onClick={(e) => e.target.className == "pop-up" && closeOtherProfile(false)}
        >
            {
                !dataLoaded ? (
                    <div className="progressbar"></div>
                ) : (
                    <>
                        <div className="other-profile">
                            <div className="line-shadow"></div>
                            <div className="header">
                                <span id="title">{Lang.player}</span>
                                <span id="subtitle">{Lang.profile}</span>
                            </div>

                            <div className="profile-side">
                                <div className="profile">
                                    <div className="player-profile-things">
                                        <div className="profile-picture">
                                            <img src={otherProfile.profile.avatar} />
                                        </div>
                                        <div className="player-thing">
                                            <div className="player-name">
                                                <span>{otherProfile.name}</span>
                                            </div>
                                            <div className="player-message">
                                                <span>{otherProfile.profile.status}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <img src={otherProfile.profile.banner} id="wallpaper" />
                                </div>

                                <div className="player-stats">
                                    <div className="stat-wrapper">
                                        <div className="stats">
                                            <img src="../../public/images/shuriken.png" id="stat-icon" />
                                            <img src="../../public/images/shuriken.png" id="stat-big-icon" />
                                            <div className="stats-name">
                                                <span>{Lang.kills}</span>
                                            </div>
                                            <span>{otherProfile.kills}</span>
                                            <div className="stats-shadow"></div>
                                        </div>

                                        <div className="stats">
                                            <img src="../../public/images/skull.png" id="stat-icon" />
                                            <img src="../../public/images/skull.png" id="stat-big-icon" />
                                            <div className="stats-name">
                                                <span>{Lang.deaths}</span>
                                            </div>
                                            <span>{otherProfile.deaths}</span>
                                            <div className="stats-shadow"></div>
                                        </div>
                                    </div>

                                    <div className="stat-wrapper">
                                        <div className="stats">
                                            <img src="../../public/images/m4a1.png" id="stat-icon" />
                                            <img src="../../public/images/m4a1.png" id="stat-big-icon" />
                                            <div className="stats-name">
                                                <span>{Lang.kda}</span>
                                            </div>
                                            <span>{modalKDA}</span>
                                            <div className="stats-shadow"></div>
                                        </div>
                                    </div>

                                    <div className="stat-wrapper">
                                        <div className="stats">
                                            <img src="../../public/images/crown.png" id="stat-icon" />
                                            <img src="../../public/images/crown.png" id="stat-big-icon" style={{
                                                rotate: "180deg",
                                                top: "-5vh",
                                            }} />
                                            <div className="stats-name">
                                                <span>{Lang.rank}</span>
                                            </div>
                                            <span style={{color: getRank.color}}>{getRank.rank}</span>
                                            <div className="stats-shadow"></div>
                                        </div>

                                        <div className="stats">
                                            <img src={`https://flagsapi.com/${otherProfile.profile.country}/shiny/64.png`} id="country-icon" />
                                            <div className="stats-name">
                                                <span>{Lang.country}</span>
                                            </div>
                                            <span>{otherProfile.profile.country}</span>
                                            <div className="stats-shadow"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </>
                )
            }
        </div>
    )
}

export default OtherProfile