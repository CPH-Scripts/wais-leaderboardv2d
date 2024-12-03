import { useContext } from "react";
import { Context } from "./Context";

const Header = () => {
    const { Lang } = useContext(Context);

    return (
        <div className="header">
            <img src="../../public/images/star.png" />
            <span id="title">{Lang.leaderboard}</span>
            <span id="subtitle">{Lang.panel}</span>
            <span id="background-title">{Lang.leaderboard}</span>
            <img src="../../public/images/star.png" />
        </div>
    )
}

export default Header;