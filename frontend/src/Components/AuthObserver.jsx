import { useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import ApiClient from '../ApiClient';

const AuthObserver = () => {
    const navigate = useNavigate();
    const location = useLocation();

    useEffect(() => {
        // 1. Storage Listener for Cross-tab Logout Synchronization
        const handleStorageChange = (e) => {
            if (e.key === 'logout-event') {
                // If another tab logged out, redirected this tab too
                window.location.href = '/auth';
            }
        };

        window.addEventListener('storage', handleStorageChange);

        // 2. Periodic Subscription Check (Polling)
        // Only run if user is logged in (token exists) and NOT on the auth page
        const checkInterval = setInterval(async () => {
            const token = localStorage.getItem('token');
            const isAuthPage = location.pathname.startsWith('/auth');

            if (token && !isAuthPage) {
                try {
                    // Check endpoint (Middleware handles the actual check)
                    await ApiClient.get('/auth/check-subscription', { silent: true });
                } catch (error) {
                    // If 403 occurs, ApiClient interceptor will handle the logout/redirect
                    console.error("Subscription check failed", error);
                }
            }
        }, 5 * 60 * 1000); // Check every 5 minutes

        return () => {
            window.removeEventListener('storage', handleStorageChange);
            clearInterval(checkInterval);
        };
    }, [location.pathname]);

    return null; // This component doesn't render anything
};

export default AuthObserver;
