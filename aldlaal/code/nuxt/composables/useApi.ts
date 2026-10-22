import axios from 'axios';
export const useApi = async (path = '', data = {},timeout=0) => {
    const config = useRuntimeConfig();
    const url_api = config.public.url_api
    const token = localStorage.getItem('token')
    const instance = axios.create({
        baseURL: url_api
    });
    const response = await instance.post(path, data, {
        headers: {
            Authorization: `${token}`,
            'Cache-Control': 'no-cache',
            Pragma: 'no-cache',
            Expires: '0'
        },
        params:{
            t: new Date().getTime()
        },
        timeout:timeout,
    });
    return response.data;
};