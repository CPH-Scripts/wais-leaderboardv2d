import { useContext, useRef, useState } from "react";
import { Context } from "./Context";
import Emit from "./Emit";

const Modal = () => {
    const { Lang, setEditableModal } = useContext(Context);
    const BannerUrl = useRef(null);
    const StatusMessage = useRef(null);

    return (
        <div className="pop-up"
            onClick={(e) => e.target.className == "pop-up" && setEditableModal(false)}
        >
            <div className="modal">
                <div className="line-shadow"></div>
                <div className="header">
                    <span id="title">{Lang.changing}</span>
                    <span id="subtitle">{Lang.profile}</span>
                </div>
                <input type="text" placeholder={Lang.banner} ref={BannerUrl} />
                <input type="text" placeholder={Lang.status} ref={StatusMessage} />
                <div className="buttons">
                    <div className="button red"
                        onClick={() => 
                            (BannerUrl.current.value.length <= 0 && StatusMessage.current.value.length <= 0 ) ? setEditableModal(false) : Emit('changeProfile', {
                                banner: BannerUrl.current.value,
                                status: StatusMessage.current.value
                            }, () => {
                                setEditableModal(false)
                            })

                        }
                    >
                        <span>{Lang.save}</span>
                    </div>
                    <div className="button"
                        onClick={() => setEditableModal(false)}
                    >
                        <span>{Lang.cancel}</span>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Modal;