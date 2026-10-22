import axios from "axios";
import {createRouter as $router} from "vue-router";

export function useAuth() {
    const config = useRuntimeConfig();
    const url = config.public.url_api;
    const token = localStorage.getItem('token');
    const timeout = 5000

    const check = async () => {
        try {
            const res = await axios.post(url+'/check',{},{
                headers: {Authorization: `${token}`, 'Cache-Control': 'no-cache', Pragma: 'no-cache', Expires: '0'},
                params:{t: new Date().getTime()}, timeout:timeout
            });
            if (res.status === 200) {
                if(res.data.status === 1){
                    usePanel().user = res.data.data
                    return 1
                }else{return 0}
            } else {return 2}
        } catch (e) {return 2}
    };

    const login = async (user, pwd,type) => {
        try{
            var res;
            if(type === 'admin'){
                res = await axios.post(url+'/admin_login',{user:user,pwd:pwd},{timeout:timeout});
            }else{
                res = await axios.post(url+'/login',{email:user,pwd:pwd,role:type},{timeout:timeout});
            }
            if(res.data.status === 1){
                localStorage.setItem('token',res.data.token)
                return 1
            }else{return 0}
        }catch (e){return 2}
    };

    const logout = () => {
        localStorage.setItem('token','')
        return 1
    };

    return {
        check,
        login,
        logout,
    };
}